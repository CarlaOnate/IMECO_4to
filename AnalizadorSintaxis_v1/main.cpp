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


std::string replaceMatchforHTML(std::string& line, std::regex reg, int type){
    std::vector<std::string> reservedWords = {"define", "lambda", "if", "cond", "else", "true", "false", "nil", "car", "cdr", "cons", "list", "apply", "map", "let", "begin", "null?", "eq?", "set!"};

//    if(type == 4){
//        auto it = std::find(reservedWords.begin(), reservedWords.end(), el);
//        if(it != reservedWords.end()) type = 8;
//    }

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
                replaceString.append("\"comment\"");
            break;
            case 4:
                replaceString.append("\"identifier\"");
            break;
            case 5:
                replaceString.append("\"parenthesis\"");
            break;
            case 6:
                replaceString.append("\"quotes\"");
            break;
            case 8:
                replaceString.append("\"reserved\"");
            break;
            default:
                replaceString.append("\"default\"");
            break;
        }
        replaceString.append("/>");
        replaceString.append(R"($&)");
        replaceString.append("</span>");
        return std::regex_replace(line, reg, replaceString);

}


int main() {
    //Regex
    std::regex numbersReg(R"(\d+)"); // Fixme: No sirvo - reconozco numeros que son parte de exp
    std::regex decimalNumbersReg(R"(^[+-]?(\d*\.)?\d+$)");  //Fixme: no sirvoo ahaa
    std::regex expNumbersReg(R"(\d+\.\d+[e|E]\d)");  // Todo: test
    std::regex commentReg(R"(;[[:print:]]*)");  // Todo: Test
    std::regex identifierReg(R"([a-zA-Z]+[\w*|\-*]*(?!\.\d))");  //Todo: Test
    std::regex parenthesisReg(R"([\(|\)\{|\}|\[|\]]+)");  //Todo: Test
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
            std::vector<std::regex> regularExps = {numbersReg, decimalNumbersReg, expNumbersReg, commentReg,
                                                   identifierReg, parenthesisReg, quotesReg};

            for(int i=0; i < regularExps.size(); i++){
//                // 0 - Numbers, 1 - decimalNum, 2 - expNumber, 3 - comment, 4 - identifier, 5 - parenthesis, 6 - quotes.
//                // Todo: No guarda varios matches, solo uno - ciclar hasta que no encuentre más match del mismo tipo
                if(i > 2){
                    changedLine = replaceMatchforHTML(line, regularExps[i], i);
                    std::cout << changedLine << "\n";
                }
            }

            resultFile.push_back(changedLine);
        }
     file.close();
    }


    outputFile.open("output.html", std::ios::out | std::ios::app);
    //Todo: Falta poner los header y DOCTYPE!

    std::cout << "VECTOR DE RESULTADO \n";
    for(const std::string& el : resultFile){
        std::cout << el << "\n";
        outputFile << el << std::endl;
    }

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
