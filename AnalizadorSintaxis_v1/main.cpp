#include <iostream>
#include <regex>
#include <fstream>

std::string replaceString(std::string className, std::string match){
    //Todo: Poner bien esta función
    std::string replace = "<span class=\"number\">";
    replace.append(match);
    replace.append("</span>");
//    std::regex_replace(match, numbers, replaceString);
    return replace;
}


int main() {
    std::fstream file("file.txt");
    std::string word;
    char c;
    std::smatch match;

    //Regex
    std::regex numbersReg("\\d+");
    std::regex delimitadores("");

    if(file.is_open()){
        while(std::getline(file, word)){
            std::regex_search(word, match, numbersReg, std::regex_constants::match_flag_type::match_any);
            for(const auto & i : match){
                std::cout << i << " |  ";
            }
        }

//        while(file.get(c)){
//            word += c;
//            if(std::regex_match(word, match, numbers)){
//                replaceString("number", match[0]);
//            }
//        }
    }
}


