#include <iostream>
#include <regex>
#include <fstream>
#include <vector>

//Carla Oñate Gardella A01653555

std::string identifierToHtml(std::string line, std::regex reg){
    std::vector<std::string> reservedWords = {"define", "lambda", "if", "cond", "else", "true", "false", "nil", "car", "cdr", "cons", "list", "apply", "map", "let", "begin", "null?", "eq?", "set!"};

    //Store matches inside vector - we do this to be able to later remove duplicates of same match
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
    std::string replace;                                    //string to store html tag to be replaced later
    std::string replacedString = line;                      //modifications of line are being stored here
    for(const auto& el : nonDuplicatesMatches){

//If match is reserved word then class is different
    if(std::find(reservedWords.begin(), reservedWords.end(), el) != reservedWords.end()){   //If match is found on reserved words vector
        replace = "<span class=\"reserved\">";
    } else {
        replace = "<span class=\"identifier\">";
    }
    replace.append(R"($&)");
    replace.append("</span>");

    //Create string to turn to regex -> \b(el)\b - this regex is the one used in the regex_replace function, this to prevent errors in matching
    std::string regexString = "\\b("; regexString.append(el); regexString.append(")\\b");
    std::regex reservedReg(regexString);  //Regular expression equal to the match word
    replacedString = std::regex_replace(replacedString, reservedReg, replace);
    }
    return replacedString;  //Return modified string with HTML tags for the identifiers or reserved words only
}



std::string replaceMatchforHTML(std::string& line, std::regex reg, int type){
    if(type == 0){
        //If string has ; then manually set tag to comment
        if(line.find(';') != std::string::npos){
            return "<span class=\"comment\">" + line + "</span>";
        }
        return identifierToHtml(line, reg);   //Function to filter identifiers and reserved words to then replace them in the line.
    } else {
        //Switch to change span tag class depending the type of regex
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
        return std::regex_replace(line, reg, replaceString);   //Returns the line with the new HTML tags
    }
}


void createHTMLfile(const std::vector<std::string>& result){
    std::fstream outputFile;
    outputFile.open("output.html", std::ios::out | std::ios::app);
    //We write the basic tags for any HTML file
    outputFile << "<!DOCTYPE html>\n" << "<html>\n" << "<body>\n" << std::endl;
    outputFile << "<link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n"
                  "<link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>\n"
                  "<link href=\"https://fonts.googleapis.com/css2?family=Roboto&display=swap\" rel=\"stylesheet\">" << std::endl;
    //We add the changes done to the file using the result vector
    for(const std::string& el : result){
        outputFile << "<p>" << el << "</p>" << std::endl;   //Write the changes done to the file
    }
    //Add the styles for each lexema - tried to add a separate CSS file but it was not working. Also the design is not very nice but I'm not very good at choosing colors
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


int main() {
    //Regex for lexemas
    std::regex decimalNumbersReg(R"(\b(?!.*?e|E)\d+(\.)*\d+)");
    std::regex expNumbersReg(R"(\d+\.\d+[e|E]\d)");
    std::regex identifierReg(R"((?!e|E)[a-zA-Z]+(\-|\w)*(?!\.\d))");
    std::regex parenthesisReg(R"([\(|\)\{|\}|\[|\]]+)");
    std::regex specialsReg(R"((?!\>)[\+\-\/\<\>\=\*]+(?!\S|\<+))");

    //We open the file
    std::fstream file("file.txt");
    std::string line;
    //Create vector to store changes
    std::vector<std::string> resultFile;  //Here all the modified lines will be stored and then will be written in a new file - this to prevent unwanted changes to the original file

//Here we read the file line by line and then call function to do the replacement
    if(file.is_open()){
    std::string changedLine;
        while(std::getline(file, line)){
            changedLine = line;
            std::vector<std::regex> regularExps = {identifierReg, specialsReg, decimalNumbersReg, expNumbersReg, parenthesisReg};
            for(int i=0; i < regularExps.size(); i++){
                // 0 - Identifier, 1- Specials,  2 - Decimal, 3 - expNum, 4 - Parenthesis  - index from regex vector
                changedLine = replaceMatchforHTML(changedLine, regularExps[i], i);
            }
            resultFile.push_back(changedLine);  //push the changes done to the line
        }
     file.close();
    }

    createHTMLfile(resultFile);
}
