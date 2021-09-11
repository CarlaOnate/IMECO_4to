#include <iostream>
#include <regex>
#include <fstream>
#include <vector>


//https://regex101.com/



std::smatch matching(std::string line, std::regex regularEx){
    std::smatch match;

    std::regex_search(line, match, regularEx, std::regex_constants::match_flag_type::match_any);

    return match;
}


std::string replaceMatchforHTML(std::string line, std::string el, std::regex reg, int type){
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
            case 3:
                replaceString.append("\"reserved\"");
            break;
            case 4:
                replaceString.append("\"comment\"");
            break;
            case 5:
                replaceString.append("\"identifier\"");
            break;
            case 6:
                replaceString.append("\"parenthesis\"");
            break;
            case 7:
                replaceString.append("\"quotes\"");
            break;
            default:
                replaceString.append("\"default\"");
            break;
        }
        replaceString.append("/>");
        replaceString.append(el);
        replaceString.append("</span>");
        std::cout << replaceString << "\n";
        std::regex_replace(line, reg, replaceString);
        return replaceString;
}


int main() {
    //Regex
    std::regex numbersReg(R"(\d+)"); // Fixme: No sirvo - reconozco numeros que son parte de exp
    std::regex decimalNumbersReg(R"(^[+-]?(\d*\.)?\d+$)");  //Fixme: no sirvoo ahaa
    std::regex expNumbersReg(R"(\d+\.\d+[e|E]\d)");  // Todo: test
    std::regex reservedWordReg(R"([a-zA-Z]+[?|!]*(?!\.))");  //Todo: Separates words - test
    std::regex commentReg(R"(;[[:print:]]*)");  // Todo: Test
    std::regex identifierReg(R"(^[a-zA-Z]+\w+(?!\.\d))");  //Todo: Test
    std::regex parenthesisReg(R"([\(|\)]*[\{|\}]*[\[|\]]*)");  //Todo: Test
//    std::regex specialsReg(R"([\+|\-|\*|\/|\<|[<=]|\>|[>=]|\=|\<|\>|\(|\)]*)");  //Fixme: I cause -> The parser did not consume the entire regular expression.
    std::regex quotesReg(R"([\"|\']\w.*[\"|\']\s)");  //Todo:test

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
            std::vector<std::regex> regularExps = {numbersReg, decimalNumbersReg, expNumbersReg, reservedWordReg, commentReg,
                                                   identifierReg, parenthesisReg, quotesReg};
            for(int i=0; i < regularExps.size(); i++){
                // 0 - Numbers, 1 - decimalNum, 2 - expNumber, 3 - reservedWords, 4 - comment, 5 - identifier, 6 - parenthesis, 7 - quotes.
                matches = matching(line, regularExps[i]);
                if(!matches.empty()){
                    if(i != 6 && (i > 3)){
                        for(auto el : matches){
                            changedLine = replaceMatchforHTML(line,el, regularExps[i], i);
                        }
                    }
//                    else {
                        //Todo: Reconocer si las palabras son reservadas o nel en esta parte
//                    }
                }
            }

            resultFile.push_back(changedLine);
        }
     file.close();
    }

    outputFile.open("output.html", std::ios::out | std::ios::app);
    //Todo: Falta poner los header y DOCTYPE!
    for(const std::string& el : resultFile){
        outputFile << el << std::endl;
    }

    outputFile.close();

}


