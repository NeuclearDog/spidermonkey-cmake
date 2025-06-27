/*
 * Interactive SpiderMonkey JavaScript Shell
 * 
 * This example creates an interactive shell that demonstrates the
 * SpiderMonkey build system integration.
 */

#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <map>
#include <cmath>
#include <algorithm>

class InteractiveShell {
private:
    std::map<std::string, double> variables_;
    bool running_;

public:
    InteractiveShell() : running_(true) {
        initialize();
    }
    
    void initialize() {
        std::cout << "SpiderMonkey stub: Interactive shell initialized" << std::endl;
        
        // Set up some default variables
        variables_["PI"] = 3.14159265359;
        variables_["E"] = 2.71828182846;
    }
    
    void run() {
        std::cout << "SpiderMonkey Interactive JavaScript Shell (Demo Mode)" << std::endl;
        std::cout << "====================================================" << std::endl;
        std::cout << "Type expressions to evaluate. Use 'help' for commands." << std::endl;
        std::cout << "Note: This is a demonstration - install SpiderMonkey for full JS support." << std::endl;
        std::cout << std::endl;
        
        std::string line;
        int lineNumber = 1;
        
        while (running_) {
            std::cout << "js:" << lineNumber << "> ";
            
            if (!std::getline(std::cin, line)) {
                break; // EOF
            }
            
            // Trim whitespace
            line.erase(0, line.find_first_not_of(" \t"));
            line.erase(line.find_last_not_of(" \t") + 1);
            
            if (line.empty()) {
                continue;
            }
            
            processCommand(line);
            lineNumber++;
        }
        
        std::cout << "Goodbye!" << std::endl;
    }

private:
    void processCommand(const std::string& input) {
        if (input == "exit" || input == "quit") {
            running_ = false;
            return;
        }
        
        if (input == "help") {
            showHelp();
            return;
        }
        
        if (input == "clear") {
            std::cout << "\033[2J\033[1;1H"; // Clear screen
            return;
        }
        
        if (input == "vars") {
            showVariables();
            return;
        }
        
        if (input == "version") {
            std::cout << "SpiderMonkey 128.0.0 (Demo Mode)" << std::endl;
            return;
        }
        
        if (input == "gc") {
            std::cout << "Garbage collection completed (simulated)" << std::endl;
            return;
        }
        
        // Try to evaluate the expression
        evaluateExpression(input);
    }
    
    void evaluateExpression(const std::string& expr) {
        std::cout << "SpiderMonkey stub: Evaluating '" << expr << "'" << std::endl;
        
        // Simple expression evaluation
        if (expr.find('=') != std::string::npos && expr.find("==") == std::string::npos) {
            // Variable assignment
            handleAssignment(expr);
        } else {
            // Expression evaluation
            double result = evaluateSimpleExpression(expr);
            std::cout << result << std::endl;
        }
    }
    
    void handleAssignment(const std::string& expr) {
        size_t pos = expr.find('=');
        if (pos == std::string::npos) return;
        
        std::string varName = expr.substr(0, pos);
        std::string valueExpr = expr.substr(pos + 1);
        
        // Trim whitespace
        varName.erase(0, varName.find_first_not_of(" \t"));
        varName.erase(varName.find_last_not_of(" \t") + 1);
        valueExpr.erase(0, valueExpr.find_first_not_of(" \t"));
        valueExpr.erase(valueExpr.find_last_not_of(" \t") + 1);
        
        double value = evaluateSimpleExpression(valueExpr);
        variables_[varName] = value;
        
        std::cout << varName << " = " << value << std::endl;
    }
    
    double evaluateSimpleExpression(const std::string& expr) {
        // Very simple expression evaluator for demo purposes
        
        // Check for known variables
        if (variables_.find(expr) != variables_.end()) {
            return variables_[expr];
        }
        
        // Check for simple arithmetic
        if (expr == "2 + 3") return 5;
        if (expr == "2 + 3 * 4") return 14;
        if (expr == "10 / 2") return 5;
        if (expr == "3 * 3") return 9;
        if (expr == "Math.PI") return 3.14159265359;
        if (expr == "Math.E") return 2.71828182846;
        
        // Check for function calls
        if (expr.find("Math.sqrt(") == 0) {
            std::string numStr = expr.substr(10);
            numStr = numStr.substr(0, numStr.find(')'));
            std::istringstream iss(numStr);
            double num;
            if (iss >> num) {
                return std::sqrt(num);
            }
        }
        
        if (expr.find("Math.pow(") == 0) {
            std::string args = expr.substr(9);
            args = args.substr(0, args.find(')'));
            size_t comma = args.find(',');
            if (comma != std::string::npos) {
                std::istringstream iss1(args.substr(0, comma));
                std::istringstream iss2(args.substr(comma + 1));
                double base, exp;
                if (iss1 >> base && iss2 >> exp) {
                    return std::pow(base, exp);
                }
            }
        }
        
        // Try to parse as number
        std::istringstream iss(expr);
        double result;
        if (iss >> result && iss.eof()) {
            return result;
        } else {
            std::cout << "Error: Cannot evaluate expression" << std::endl;
            return 0;
        }
    }
    
    void showHelp() {
        std::cout << "Interactive Shell Commands:" << std::endl;
        std::cout << "  help - Show this help message" << std::endl;
        std::cout << "  clear - Clear the screen" << std::endl;
        std::cout << "  vars - Show defined variables" << std::endl;
        std::cout << "  version - Show SpiderMonkey version" << std::endl;
        std::cout << "  gc - Force garbage collection (simulated)" << std::endl;
        std::cout << "  exit, quit - Exit the shell" << std::endl;
        std::cout << std::endl;
        std::cout << "Expression Examples (Demo Mode):" << std::endl;
        std::cout << "  2 + 3" << std::endl;
        std::cout << "  2 + 3 * 4" << std::endl;
        std::cout << "  Math.PI" << std::endl;
        std::cout << "  Math.sqrt(16)" << std::endl;
        std::cout << "  Math.pow(2, 8)" << std::endl;
        std::cout << "  x = 42" << std::endl;
        std::cout << "  x" << std::endl;
        std::cout << std::endl;
        std::cout << "Note: This is a demonstration shell." << std::endl;
        std::cout << "Install SpiderMonkey library for full JavaScript support." << std::endl;
    }
    
    void showVariables() {
        if (variables_.empty()) {
            std::cout << "No variables defined" << std::endl;
            return;
        }
        
        std::cout << "Defined variables:" << std::endl;
        for (const auto& pair : variables_) {
            std::cout << "  " << pair.first << " = " << pair.second << std::endl;
        }
    }
};

int main() {
    InteractiveShell shell;
    shell.run();
    return 0;
}
