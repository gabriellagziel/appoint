#!/bin/bash

# Fix malformed catch blocks throughout the codebase
find . -name "*.dart" -type f -exec sed -i 's/} catch (e) {e) {/} catch (e) {/g' {} +

echo "Fixed all malformed catch blocks"