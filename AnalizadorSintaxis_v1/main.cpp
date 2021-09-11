#include <iostream>
#include <regex>
#include <fstream>
#include <vector>


//https://regex101.com/


std::string replaceMatchforHTML(std::string& line, std::regex reg, int type){
    std::vector<std::string> reservedWords = {"define", "lambda", "if", "cond", "else", "true", "false", "nil", "car", "cdr", "cons", "list", "apply", "map", "let", "begin", "null?", "eq?", "set!"};


    if(type == 3){
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
            if(std::find(reservedWords.begin(), reservedWords.end(), it->str()) != reservedWords.end()){
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
                case 0:
                    replaceString.append("\"number\"");
                break;
                case 1:
                    replaceString.append("\"decimal\"");
                break;
                case 2:
                    replaceString.append("\"exp\"");
                break;
                case 4:
                    replaceString.append("\"parenthesis\"");
                break;
                case 5:
                    replaceString.append("\"quotes\"");
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
    std::regex numbersReg(R"(\d+)"); // Fixme: No sirvo - reconozco numeros que son parte de exp
    std::regex decimalNumbersReg(R"(^[+-]?(\d*\.)?\d+$)");  //Fixme: no sirvoo ahaa
    std::regex expNumbersReg(R"(\d+\.\d+[e|E]\d)");  // Todo: test
    std::regex identifierReg(R"([a-zA-Z]+[\w*|\-*]*(?!\.\d))");  //Indentifica mal los comentarios
    std::regex parenthesisReg(R"([\(|\)\{|\}|\[|\]]+)");
//    std::regex specialsReg(R"([\+|\-|\*|\/|\<|[<=]|\>|[>=]|\=|\<|\>|\(|\)]*)");  //Fixme: I cause -> The parser did not consume the entire regular expression.
    std::regex quotesReg(R"([\"|\']\w.*[\"|\']\s)");


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
            std::vector<std::regex> regularExps = {numbersReg, decimalNumbersReg, expNumbersReg,
                                                   identifierReg, parenthesisReg, quotesReg};

            for(int i=0; i < regularExps.size(); i++){
//                // 0 - Numbers, 1 - decimalNum, 2 - expNumber, 3 - identifier, 4 - parenthesis, 5 - quotes.
                if(i > 2){
                    changedLine = replaceMatchforHTML(changedLine, regularExps[i], i);
                }
            }
            resultFile.push_back(changedLine);
        }
     file.close();
    }


    outputFile.open("output.html", std::ios::out | std::ios::app);
    //Todo: Falta poner los header y DOCTYPE!
    outputFile << "<!DOCTYPE html>\n" << "<html>\n" << "<body>\n" << std::endl;
    std::cout << "VECTOR DE RESULTADO \n";
    for(const std::string& el : resultFile){
        std::cout << el << "\n";
        outputFile << el << std::endl;
    }
    outputFile << "</body>\n" << "</html>\n" << std::endl;

    outputFile.close();

}



//
//                std::regex_iterator<std::string::iterator> it (line.begin(), line.end(), regularExps[i]);
//                std::regex_iterator<std::string::iterator> end;
//                std::cout << "i = " << i << "\n";
//                while(it != end){
//                    std::cout << it->str() << std::endl;
//                    ++it;
//                }
//                std::cout << "\n\n";


//                if(!matches.empty()){
//                    if((i > 2)){
//                        for(auto el : matches){
//                            changedLine = replaceMatchforHTML(line,el, regularExps[i], i);
//                        }
//                    }
//                }
