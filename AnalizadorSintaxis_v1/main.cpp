#include <iostream>
#include <regex>
#include <fstream>
#include <vector>


//https://regex101.com/



std::smatch matching(std::string line, std::regex regularEx){

    std::smatch match;
//    std::smatch numberMatch;
//    std::smatch decimalNumbersMatch;
//    std::smatch expNumbersMatch;
//    std::smatch reservedWordMatch;
//    std::smatch commentMatch;
//    std::smatch identifierWordMatch;
//    std::smatch parenthesisMatch;
//    std::smatch specialMatch;
//    std::smatch quotesMatch;

//    //Regex
//    std::regex numbersReg(R"(\d+)"); // Fixme: No sirvo - reconozco numeros que son parte de exp
//    std::regex decimalNumbersReg(R"(^[+-]?(\d*\.)?\d+$)");  //Fixme: no sirvoo ahaa
//    std::regex expNumbersReg(R"(\d+\.\d+[e|E]\d)");  // Todo: test
//    std::regex reservedWordReg(R"([a-zA-Z]+[?|!]*(?!\.))");  //Todo: Separates words - test
//    std::regex commentReg(R"(;[[:print:]]*)");  // Todo: Test
//    std::regex identifierReg(R"(^[a-zA-Z]+\w+(?!\.\d))");  //Todo: Test
//    std::regex parenthesisReg(R"([\(|\)]*[\{|\}]*[\[|\]]*)");  //Todo: Test
//    std::regex specialsReg(R"([\+|\-|\*|\/|\<|[<=]|\>|[>=]|\=|\<|\>|\(|\)]*)");  //Todo: test
//    std::regex quotesReg(R"([\"|\']\w.*[\"|\']\s)");  //Todo:test
//
//    //Number
    std::regex_search(line, match, regularEx, std::regex_constants::match_flag_type::match_any);
//    //Decimal Numbers
//    std::regex_search(line, decimalNumbersMatch, decimalNumbersReg, std::regex_constants::match_flag_type::match_any);
//    //Exp numbers - Fixme: no sirvo
//    std::regex_search(line, expNumbersMatch, expNumbersReg, std::regex_constants::match_flag_type::match_any);
//    //ReservedWord
//    std::regex_search(line, reservedWordMatch, reservedWordReg, std::regex_constants::match_flag_type::match_any);
//    //Comment
//    std::regex_search(line, commentMatch, commentReg, std::regex_constants::match_flag_type::match_any);
//    //Identifier
//    std::regex_search(line, identifierWordMatch, identifierReg, std::regex_constants::match_flag_type::match_any);
//    //Parenthesis
//    std::regex_search(line, parenthesisMatch, parenthesisReg, std::regex_constants::match_flag_type::match_any);
//    //specials
//    std::regex_search(line, specialMatch, specialsReg, std::regex_constants::match_flag_type::match_any);
//    //quotes
//    std::regex_search(line, quotesMatch, quotesReg, std::regex_constants::match_flag_type::match_any);
    return match;

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

            //Number
            auto matches = matching(line, numbersReg);
            if(!matches.empty()){
                for(auto el : matches){
                    std::string replaceString = "<span class=\"numbers\">";
                    replaceString.append(el);
                    replaceString.append("</span>");
                    changedLine = std::regex_replace(line, numbersReg, replaceString);
                    std::cout << changedLine << "\n";
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


