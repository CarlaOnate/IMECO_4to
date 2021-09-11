#include <iostream>
#include <regex>
#include <fstream>
#include <vector>


//https://regex101.com/


std::string replaceMatchforHTML(std::string& line, std::regex reg, int type){
    std::vector<std::string> reservedWords = {"define", "lambda", "if", "cond", "else", "true", "false", "nil", "car", "cdr", "cons", "list", "apply", "map", "let", "begin", "null?", "eq?", "set!"};


    if(type == 0){
        //If its comment then manually set tag
        if(line.find(';') != std::string::npos){
            return "<span class=\"comment\">" + line + "</span>";
        }

        //Store matches inside vector
        std::vector<std::string> nonDuplicatesMatches;
        std::regex_iterator<std::string::iterator> it (line.begin(), line.end(), reg);
        std::regex_iterator<std::string::iterator> end;
        while(it != end){
            nonDuplicatesMatches.push_back(it->str());
            ++it;
        }
        //Removing duplicate matches from vector
        std::sort(nonDuplicatesMatches.begin(), nonDuplicatesMatches.end());
        auto last = std::unique(nonDuplicatesMatches.begin(), nonDuplicatesMatches.end());
        nonDuplicatesMatches.erase(last, nonDuplicatesMatches.end());

        //Replace matches with HTML tag
        std::string replace;
        std::string replacedString = line;
        for(const auto& el : nonDuplicatesMatches){
            std::cout << el << std::endl;
            //If match is reseved word then class type is different
            if(std::find(reservedWords.begin(), reservedWords.end(), el) != reservedWords.end()){
                replace = "<span class=\"reserved\">";
            } else {
                replace = "<span class=\"identifier\">";
            }
            replace.append(R"($&)");
            replace.append("</span>");
            //Create string for regex -> \b(el)\b
            std::string regexString = "\\b("; regexString.append(el); regexString.append(")\\b");
            std::regex reservedReg(regexString);  //Regular expression equal to the match word
            replacedString = std::regex_replace(replacedString, reservedReg, replace);
        }
        return replacedString;


    } else {
        std::string replaceString = "<span class=";
            switch (type) {
                case 1:
                    replaceString.append("\"specials\"");
                break;
                case 2:
                    replaceString.append("\"decimal\"");
                break;
                case 3:
                    replaceString.append("\"exp\"");
                break;
                case 4:
                    replaceString.append("\"parenthesis\"");
                break;
                default:
                    replaceString.append("\"default\"");
                break;
            }
        replaceString.append(">");
        replaceString.append(R"($&)");
        replaceString.append("</span>");
        return std::regex_replace(line, reg, replaceString);
    }


}


int main() {
    //Regex
    std::regex decimalNumbersReg(R"(\b(?!.*?e|E)\d+(\.)*\d+)");
    std::regex expNumbersReg(R"(\d+\.\d+[e|E]\d)");
    std::regex identifierReg(R"((?!e|E)[a-zA-Z]+(\-|\w)*(?!\.\d))");
    std::regex parenthesisReg(R"([\(|\)\{|\}|\[|\]]+)");
    std::regex specialsReg(R"((?!\>)[\+\-\/\<\>\=\*]+(?!\S|\<+))");


    std::fstream file("file.txt");
    std::string line;
    std::vector<std::string> resultFile;

    std::fstream outputFile;

    if(file.is_open()){

    std::string changedLine;
        while(std::getline(file, line)){
            changedLine = line;
            int type = 0;
            std::smatch matches;
            std::vector<std::regex> regularExps = {identifierReg, specialsReg, decimalNumbersReg, expNumbersReg, parenthesisReg};

            for(int i=0; i < regularExps.size(); i++){
                // 0 - Identifier, 1- Specials,  2 - Decimal, 3 - expNum, 4 - Parenthesis
                changedLine = replaceMatchforHTML(changedLine, regularExps[i], i);
            }
            resultFile.push_back(changedLine);
        }
     file.close();
    }


    outputFile.open("output.html", std::ios::out | std::ios::app);
    //We write the basic tags for any HTML file
    outputFile << "<!DOCTYPE html>\n" << "<html>\n" << "<body>\n" << std::endl;
    outputFile << "<link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n"
                  "<link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>\n"
                  "<link href=\"https://fonts.googleapis.com/css2?family=Roboto&display=swap\" rel=\"stylesheet\">" << std::endl;
    std::cout << "VECTOR DE RESULTADO \n";
    for(const std::string& el : resultFile){
        std::cout << el << "\n";
        outputFile << "<p>" << el << "</p>" << std::endl;
    }
    outputFile << "<style>\n"
                  "    body {\n"
                  "        font-family: 'Roboto', sans-serif;\n"
                  "        background-color: antiquewhite;\n"
                  "        color: black;\n"
                  "    }\n"
                  "\n"
                  "    .identifier {\n"
                  "        color: blueviolet;\n"
                  "        font-weight: bold;\n"
                  "    }\n"
                  "\n"
                  "    .decimal {\n"
                  "        color: dimgrey;\n"
                  "    }\n"
                  "\n"
                  "    .exp {\n"
                  "        color: cadetblue;\n"
                  "    }\n"
                  "\n"
                  "    .parenthesis {\n"
                  "        color: brown;\n"
                  "    }\n"
                  "\n"
                  "    .reserved {\n"
                  "        color: chocolate;\n"
                  "    }\n"
                  "\n"
                  "    .comment {\n"
                  "        color: blue;\n"
                  "    }\n"
                  "    .specials {\n"
                  "        color: green;\n"
                  "    }\n"
                  "</style>" << std::endl;
    outputFile << "</body>\n" << "</html>\n" << std::endl;

    outputFile.close();

}
