#!/usr/bin/env node

const { Command } = require('commander');
const axios = require('axios');
const fs = require('fs');
const path = require('path');
const chalk = require('chalk');
const ora = require('ora');
const Table = require('cli-table3');
const inquirer = require('inquirer');

const program = new Command();

// Configuration
let config = {
    apiKey: process.env.APPOINT_API_KEY,
    baseUrl: process.env.APPOINT_BASE_URL || 'https://api.appoint.com/v2',
    sandboxId: process.env.APPOINT_SANDBOX_ID
};

// Initialize CLI
program
    .name('appoint-enterprise')
    .description('App-Oint Enterprise CLI tool')
    .version('1.0.0');

// Configure command
program
    .command('configure')
    .description('Configure API credentials and settings')
    .action(async () => {
        const answers = await inquirer.prompt([
            {
                type: 'input',
                name: 'apiKey',
                message: 'Enter your App-Oint API key:',
                default: config.apiKey
            },
            {
                type: 'input',
                name: 'baseUrl',
                message: 'Enter API base URL:',
                default: config.baseUrl
            },
            {
                type: 'input',
                name: 'sandboxId',
                message: 'Enter sandbox ID (optional):',
                default: config.sandboxId
            }
        ]);

        config = { ...config, ...answers };

        // Save to config file
        const configPath = path.join(process.env.HOME || process.env.USERPROFILE, '.appoint-enterprise.json');
        fs.writeFileSync(configPath, JSON.stringify(config, null, 2));

        console.log(chalk.green('✓ Configuration saved successfully'));
    });

// Bulk import command
program
    .command('import')
    .description('Bulk import data from file')
    .option('-f, --file <file>', 'Input file path')
    .option('-t, --type <type>', 'Data type (users, bookings, businesses)')
    .option('-s, --sandbox', 'Use sandbox environment')
    .action(async (options) => {
        const spinner = ora('Importing data...').start();

        try {
            if (!options.file || !options.type) {
                throw new Error('File and type are required');
            }

            const filePath = path.resolve(options.file);
            if (!fs.existsSync(filePath)) {
                throw new Error('File not found');
            }

            const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
            const url = options.sandbox && config.sandboxId
                ? `${config.baseUrl.replace('api.appoint.com', `sandbox-${config.sandboxId}.appoint.com`)}/api/enterprise/bulk-operations`
                : `${config.baseUrl}/api/enterprise/bulk-operations`;

            const response = await axios.post(url, {
                operation: 'import',
                dataType: options.type,
                data: data
            }, {
                headers: {
                    'Authorization': `Bearer ${config.apiKey}`,
                    'Content-Type': 'application/json'
                }
            });

            spinner.succeed('Import completed successfully');
            console.log(chalk.blue(`Operation ID: ${response.data.operationId}`));

        } catch (error) {
            spinner.fail('Import failed');
            console.error(chalk.red(error.message));
        }
    });

// Bulk export command
program
    .command('export')
    .description('Bulk export data to file')
    .option('-t, --type <type>', 'Data type (users, bookings, businesses)')
    .option('-o, --output <file>', 'Output file path')
    .option('-s, --sandbox', 'Use sandbox environment')
    .action(async (options) => {
        const spinner = ora('Exporting data...').start();

        try {
            if (!options.type) {
                throw new Error('Data type is required');
            }

            const url = options.sandbox && config.sandboxId
                ? `${config.baseUrl.replace('api.appoint.com', `sandbox-${config.sandboxId}.appoint.com`)}/api/enterprise/bulk-operations`
                : `${config.baseUrl}/api/enterprise/bulk-operations`;

            const response = await axios.post(url, {
                operation: 'export',
                dataType: options.type
            }, {
                headers: {
                    'Authorization': `Bearer ${config.apiKey}`,
                    'Content-Type': 'application/json'
                }
            });

            const outputFile = options.output || `export_${options.type}_${Date.now()}.json`;
            fs.writeFileSync(outputFile, JSON.stringify(response.data, null, 2));

            spinner.succeed('Export completed successfully');
            console.log(chalk.blue(`Data exported to: ${outputFile}`));

        } catch (error) {
            spinner.fail('Export failed');
            console.error(chalk.red(error.message));
        }
    });

// User management commands
program
    .command('users')
    .description('User management operations')
    .option('-l, --list', 'List all users')
    .option('-c, --create', 'Create new user')
    .option('-u, --update <id>', 'Update user by ID')
    .option('-d, --delete <id>', 'Delete user by ID')
    .option('-s, --sandbox', 'Use sandbox environment')
    .action(async (options) => {
        const spinner = ora('Processing user operation...').start();

        try {
            const url = options.sandbox && config.sandboxId
                ? `${config.baseUrl.replace('api.appoint.com', `sandbox-${config.sandboxId}.appoint.com`)}/api/enterprise/users`
                : `${config.baseUrl}/api/enterprise/users`;

            if (options.list) {
                const response = await axios.get(url, {
                    headers: { 'Authorization': `Bearer ${config.apiKey}` }
                });

                const table = new Table({
                    head: ['ID', 'Email', 'Name', 'Company', 'Role', 'Created']
                });

                response.data.forEach(user => {
                    table.push([
                        user.id,
                        user.email,
                        `${user.firstName} ${user.lastName}`,
                        user.company || '-',
                        user.role,
                        new Date(user.createdAt).toLocaleDateString()
                    ]);
                });

                spinner.succeed('Users retrieved successfully');
                console.log(table.toString());
            }

        } catch (error) {
            spinner.fail('User operation failed');
            console.error(chalk.red(error.message));
        }
    });

// Audit logs command
program
    .command('audit-logs')
    .description('Retrieve audit logs')
    .option('-s, --start <date>', 'Start date (YYYY-MM-DD)')
    .option('-e, --end <date>', 'End date (YYYY-MM-DD)')
    .option('-u, --user <id>', 'Filter by user ID')
    .option('-a, --action <action>', 'Filter by action')
    .option('-o, --output <file>', 'Output file path')
    .option('-s, --sandbox', 'Use sandbox environment')
    .action(async (options) => {
        const spinner = ora('Retrieving audit logs...').start();

        try {
            const params = new URLSearchParams();
            if (options.start) params.append('startDate', options.start);
            if (options.end) params.append('endDate', options.end);
            if (options.user) params.append('userId', options.user);
            if (options.action) params.append('action', options.action);

            const url = options.sandbox && config.sandboxId
                ? `${config.baseUrl.replace('api.appoint.com', `sandbox-${config.sandboxId}.appoint.com`)}/api/enterprise/audit-logs`
                : `${config.baseUrl}/api/enterprise/audit-logs`;

            const response = await axios.get(`${url}?${params.toString()}`, {
                headers: { 'Authorization': `Bearer ${config.apiKey}` }
            });

            if (options.output) {
                fs.writeFileSync(options.output, JSON.stringify(response.data, null, 2));
                spinner.succeed(`Audit logs exported to: ${options.output}`);
            } else {
                const table = new Table({
                    head: ['Timestamp', 'User', 'Action', 'Resource', 'Details']
                });

                response.data.forEach(log => {
                    table.push([
                        new Date(log.timestamp).toLocaleString(),
                        log.userId,
                        log.action,
                        log.resource,
                        JSON.stringify(log.details).substring(0, 50) + '...'
                    ]);
                });

                spinner.succeed('Audit logs retrieved successfully');
                console.log(table.toString());
            }

        } catch (error) {
            spinner.fail('Failed to retrieve audit logs');
            console.error(chalk.red(error.message));
        }
    });

// Usage metrics command
program
    .command('usage')
    .description('Get usage metrics and analytics')
    .option('-p, --period <period>', 'Time period (day, week, month)')
    .option('-s, --sandbox', 'Use sandbox environment')
    .action(async (options) => {
        const spinner = ora('Retrieving usage metrics...').start();

        try {
            const params = new URLSearchParams();
            if (options.period) params.append('period', options.period);

            const url = options.sandbox && config.sandboxId
                ? `${config.baseUrl.replace('api.appoint.com', `sandbox-${config.sandboxId}.appoint.com`)}/api/enterprise/usage-metrics`
                : `${config.baseUrl}/api/enterprise/usage-metrics`;

            const response = await axios.get(`${url}?${params.toString()}`, {
                headers: { 'Authorization': `Bearer ${config.apiKey}` }
            });

            const metrics = response.data;

            console.log(chalk.blue('\n📊 Usage Metrics'));
            console.log(chalk.green(`API Calls: ${metrics.apiCalls.toLocaleString()}`));
            console.log(chalk.green(`Data Transfer: ${(metrics.dataTransfer / 1024 / 1024).toFixed(2)} MB`));
            console.log(chalk.green(`Active Users: ${metrics.activeUsers}`));
            console.log(chalk.green(`Period: ${metrics.period}`));

            spinner.succeed('Usage metrics retrieved successfully');

        } catch (error) {
            spinner.fail('Failed to retrieve usage metrics');
            console.error(chalk.red(error.message));
        }
    });

// Health check command
program
    .command('health')
    .description('Check API health and connectivity')
    .option('-s, --sandbox', 'Use sandbox environment')
    .action(async (options) => {
        const spinner = ora('Checking health...').start();

        try {
            const url = options.sandbox && config.sandboxId
                ? `${config.baseUrl.replace('api.appoint.com', `sandbox-${config.sandboxId}.appoint.com`)}/health`
                : `${config.baseUrl}/health`;

            const response = await axios.get(url, {
                headers: { 'Authorization': `Bearer ${config.apiKey}` }
            });

            spinner.succeed('Health check passed');
            console.log(chalk.green(`Status: ${response.data.status}`));
            console.log(chalk.blue(`Timestamp: ${response.data.timestamp}`));

        } catch (error) {
            spinner.fail('Health check failed');
            console.error(chalk.red(error.message));
        }
    });

// Parse command line arguments
program.parse(process.argv);

// Show help if no command provided
if (!process.argv.slice(2).length) {
    program.outputHelp();
} 