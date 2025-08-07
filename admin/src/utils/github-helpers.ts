import { Octokit } from '@octokit/rest';

// Initialize Octokit with GitHub token
const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN,
});

export interface GitHubConfig {
  owner: string;
  repo: string;
  token?: string;
}

/**
 * Get open pull requests for a specific branch
 */
export async function getOpenPullRequests(branch: string, config: GitHubConfig) {
  try {
    const response = await octokit.pulls.list({
      owner: config.owner,
      repo: config.repo,
      state: 'open',
      head: `${config.owner}:${branch}`,
    });
    
    return response.data;
  } catch (error) {
    console.error('Error fetching open PRs:', error);
    throw error;
  }
}

/**
 * Comment on a pull request
 */
export async function commentOnPR(
  prNumber: number, 
  comment: string, 
  config: GitHubConfig
) {
  try {
    const response = await octokit.issues.createComment({
      owner: config.owner,
      repo: config.repo,
      issue_number: prNumber,
      body: comment,
    });
    
    console.log(`✅ Commented on PR #${prNumber}`);
    return response.data;
  } catch (error) {
    console.error('Error commenting on PR:', error);
    throw error;
  }
}

/**
 * Get CI/CD status for a specific commit
 */
export async function getCommitStatus(
  sha: string, 
  config: GitHubConfig
) {
  try {
    const response = await octokit.repos.getCombinedStatusForRef({
      owner: config.owner,
      repo: config.repo,
      ref: sha,
    });
    
    return response.data;
  } catch (error) {
    console.error('Error fetching commit status:', error);
    throw error;
  }
}

/**
 * Monitor branch merges and trigger actions
 */
export async function monitorBranchMerges(
  baseBranch: string, 
  config: GitHubConfig,
  onMerge?: (pr: any) => void
) {
  try {
    const response = await octokit.pulls.list({
      owner: config.owner,
      repo: config.repo,
      state: 'closed',
      base: baseBranch,
      sort: 'updated',
      direction: 'desc',
      per_page: 10,
    });
    
    const mergedPRs = response.data.filter(pr => pr.merged_at);
    
    if (onMerge && mergedPRs.length > 0) {
      mergedPRs.forEach(pr => onMerge(pr));
    }
    
    return mergedPRs;
  } catch (error) {
    console.error('Error monitoring branch merges:', error);
    throw error;
  }
}

/**
 * Auto-run CI checks on PR merge
 */
export async function autoRunCIChecks(
  prNumber: number, 
  config: GitHubConfig
) {
  try {
    // Trigger CI checks by updating PR
    await octokit.pulls.update({
      owner: config.owner,
      repo: config.repo,
      pull_number: prNumber,
      title: `[CI] Auto-triggered checks for PR #${prNumber}`,
    });
    
    console.log(`✅ Triggered CI checks for PR #${prNumber}`);
  } catch (error) {
    console.error('Error triggering CI checks:', error);
    throw error;
  }
}

/**
 * Get latest release information
 */
export async function getLatestRelease(config: GitHubConfig) {
  try {
    const response = await octokit.repos.getLatestRelease({
      owner: config.owner,
      repo: config.repo,
    });
    
    return response.data;
  } catch (error) {
    console.error('Error fetching latest release:', error);
    throw error;
  }
}

/**
 * Create a new release
 */
export async function createRelease(
  tagName: string,
  releaseNotes: string,
  config: GitHubConfig
) {
  try {
    const response = await octokit.repos.createRelease({
      owner: config.owner,
      repo: config.repo,
      tag_name: tagName,
      name: `Release ${tagName}`,
      body: releaseNotes,
      draft: false,
      prerelease: false,
    });
    
    console.log(`✅ Created release ${tagName}`);
    return response.data;
  } catch (error) {
    console.error('Error creating release:', error);
    throw error;
  }
} 