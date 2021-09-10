#include <iostream>
#include <regex>
#include <fstream>



int main() {
    std::fstream file("file.txt");
    std::string line;
    std::smatch match;

    //Regex
    std::regex numbers("[[:digit:]]*");
    std::regex delimitadores("");

    if(file.is_open()){
        while(std::getline(file, line)){
            std::cout << line << "\n" ;


            if(std::regex_match(line, match, numbers)){
                std::cout << match[0];
                std::string replaceString = "<span class=\"number\">";
                replaceString.append(match[0]);
                replaceString.append("</span>");
                std::regex_replace(line, numbers, replaceString);
            };
        }
    }
}


