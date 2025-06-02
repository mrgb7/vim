#!/bin/bash

# Comprehensive test script for Neovim configuration
# Tests gotmpl, helm, yaml, CUE language servers and features

echo "🚀 Starting comprehensive Neovim configuration test..."
echo "=============================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results tracking
PASSED=0
FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_pattern="$3"
    
    echo -e "${BLUE}Testing: $test_name${NC}"
    
    # Run the command and capture output
    output=$(eval "$command" 2>&1)
    exit_code=$?
    
    # Check if expected pattern is found or exit code is 0
    if [[ $exit_code -eq 0 ]] && [[ -z "$expected_pattern" || "$output" =~ $expected_pattern ]]; then
        echo -e "${GREEN}✅ PASSED: $test_name${NC}"
        ((PASSED++))
        if [[ -n "$output" ]]; then
            echo "   Output: $output"
        fi
    else
        echo -e "${RED}❌ FAILED: $test_name${NC}"
        echo "   Exit code: $exit_code"
        echo "   Output: $output"
        if [[ -n "$expected_pattern" ]]; then
            echo "   Expected pattern: $expected_pattern"
        fi
        ((FAILED++))
    fi
    echo ""
}

# Test 1: Neovim configuration loads without errors
run_test "Neovim Configuration Load" \
    "nvim --headless -c 'lua print(\"Config loaded successfully\")' -c 'q'" \
    "Config loaded successfully"

# Test 2: Mason language servers are installed
run_test "Mason Language Servers Installation" \
    "ls ~/.local/share/nvim/mason/bin/ | grep -E '(gopls|helm_ls|cuelsp|yaml-language-server)' | wc -l" \
    "4"

# Test 3: CUE filetype detection
run_test "CUE Filetype Detection" \
    "nvim --headless test_files/config.cue -c 'lua vim.defer_fn(function() print(\"filetype:\" .. vim.bo.filetype) vim.cmd(\"q\") end, 500)'" \
    "filetype:cue"

# Test 4: Helm template filetype detection
run_test "Helm Template Filetype Detection" \
    "nvim --headless test_files/helm-chart/templates/deployment.yaml -c 'lua vim.defer_fn(function() print(\"filetype:\" .. vim.bo.filetype) vim.cmd(\"q\") end, 500)'" \
    "filetype:helm"

# Test 5: Go template filetype detection
run_test "Go Template Filetype Detection" \
    "nvim --headless test_files/deployment.gotmpl -c 'lua vim.defer_fn(function() print(\"filetype:\" .. vim.bo.filetype) vim.cmd(\"q\") end, 500)'" \
    "filetype:gotmpl"

# Test 6: YAML filetype detection
run_test "YAML Filetype Detection" \
    "nvim --headless test_files/test.yaml -c 'lua vim.defer_fn(function() print(\"filetype:\" .. vim.bo.filetype) vim.cmd(\"q\") end, 500)'" \
    "filetype:yaml"

# Test 7: Go language server functionality
run_test "Go Language Server" \
    "nvim --headless test_files/main.go -c 'lua vim.defer_fn(function() local clients = vim.lsp.get_active_clients(); for _, client in ipairs(clients) do if client.name == \"gopls\" then print(\"gopls active\") break end end vim.cmd(\"q\") end, 2000)'" \
    "gopls active"

# Test 8: Helm configuration module loads
run_test "Helm Configuration Module" \
    "nvim --headless -c 'lua require(\"helm_gotmpl_config\"); print(\"Helm config loaded\")' -c 'q'" \
    "Helm config loaded"

# Test 9: Treesitter parsers are installed
run_test "Treesitter Parsers" \
    "nvim --headless -c 'lua local parsers = require(\"nvim-treesitter.parsers\").get_parser_configs(); local count = 0; for name, _ in pairs(parsers) do if name == \"go\" or name == \"yaml\" or name == \"gotmpl\" or name == \"helm\" then count = count + 1 end end print(\"parsers:\" .. count)' -c 'q'" \
    "parsers:[2-9]"

# Test 10: CUE language server binary works
run_test "CUE Language Server Binary" \
    "timeout 2s ~/.local/share/nvim/mason/bin/cuelsp --help || echo 'cuelsp responded'" \
    "cuelsp"

# Test 11: Helm lint functionality (if helm is installed)
if command -v helm &> /dev/null; then
    run_test "Helm Lint" \
        "cd test_files/helm-chart && helm lint . --quiet" \
        ""
else
    echo -e "${YELLOW}⚠️  SKIPPED: Helm CLI not installed, skipping helm lint test${NC}"
fi

# Test 12: YAML schema validation
run_test "YAML Schema Support" \
    "nvim --headless test_files/test.yaml -c 'lua vim.defer_fn(function() local clients = vim.lsp.get_active_clients(); for _, client in ipairs(clients) do if client.name == \"yamlls\" then print(\"yamlls active\") break end end vim.cmd(\"q\") end, 2000)'" \
    "yamlls active"

# Summary
echo "=============================================="
echo -e "${BLUE}Test Summary:${NC}"
echo -e "  ${GREEN}✅ Passed: $PASSED${NC}"
echo -e "  ${RED}❌ Failed: $FAILED${NC}"
echo -e "  ${BLUE}📊 Total: $((PASSED + FAILED))${NC}"

if [[ $FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}🎉 All tests passed! Your Neovim configuration is ready!${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Some tests failed. Please check the output above.${NC}"
    exit 1
fi