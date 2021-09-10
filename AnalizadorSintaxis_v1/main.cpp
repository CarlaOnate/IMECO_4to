#include <iostream>
#include <regex>
#include <fstream>
#include <vector>



int main() {
    std::fstream file("file.txt");
    std::string line;
    std::vector<std::string> resultFile;

    std::fstream outputFile;


    //Regex
    std::regex numbersReg(R"(\d+)");
    std::regex numbersE_Reg(R"(^[+-]?(\d*\.)?\d+$)");

    if(file.is_open()){
    std::smatch numberMatch;
    std::smatch testMatch;
    std::string changedLine;
        while(std::getline(file, line)){
            changedLine = line;
            //Number
            std::regex_search(line, numberMatch, numbersReg, std::regex_constants::match_flag_type::match_any);
            //Test
            std::regex_search(line, testMatch, numbersE_Reg, std::regex_constants::match_flag_type::match_any);

            if(!numberMatch.empty()){
                //Detecto numeros en la línea
                std::string replaceString = "<span class=\"numbers\">";
                replaceString.append(numberMatch[0]);
                replaceString.append("</span>");

                changedLine = std::regex_replace(line, numbersReg, replaceString);
                std::cout << changedLine;
            }

        }
     file.close();
    }

    outputFile.open("output.html");
    //Todo: Falta poner los header y DOCTYPE!
    for(const std::string& el : resultFile){
        outputFile << el << std::endl;
    }

    outputFile.close();

}


