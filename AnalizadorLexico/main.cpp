// Carla Oñate Gardella A01653555

#include <iostream>
#include <fstream>
#include "vector"
#include <string>
#include <algorithm>



//9 estados intermedios y 22 caracteres en total  -- AGREGRA :
//            letra(ad-fz), dig, esp,  +,  -,   *,   /,   <,   >,  =,   (,   ),   [,    ],   {,    },   ;,  ,,   ',   ",   #,   \,   enter, .,  raro, (e,E), _,   :,  |
int MT [10][29] = {
/* 0 */               {6,   2,   -1,   131, 1,   123, 123, 9,   9,   130, 124, 124, 124, 124, 124, 124, 7,   126, 127, 127, 128, 129,  -1,    125, -1,   6,   123, 120, 129},
/* 1 */               {132, 2,   132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132,  132,  132, -1,   132, 132, 132, 132},
/* 2 */               {100, 2,   100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,  100,  3,   -1,   100, 100, 100, 100},
/* 3 */               {-1,  4,   -1,  -1,  -1,  -1   -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,   -1,   -1,  -1,   -1,  -1,  -1,  -1},
/* 4 */               {101, 4,   101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101,  101,  101, -1,   5,   101, 101, 101},
/* 5 */               {-1,  102, -1,  -1,  -1   -1   -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,   -1,   -1,  -1,   -1,  -1,  -1,  -1},
/* 6 */               {6,   6,   103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 103,  103,  103, -1,   6,   6,   103, 103},
/* 7 */               {8,   7,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,    -1,    8,   -1,   8,   8,   8,  8},
/* 8 */               {8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,    104,    8,   -1,   8,   8,   8, 8},
/* 9 */               {122, 122, 122, 122, 122, 122, 122, 122, 122, 133, 122, 122, 122, 122, 122, 122, 122, 122, 122, 122, 122, 122,  122,  122, -1,   122, 122, 122, 122},

 };


int getCol(int edo, char c){
    std::vector<char> numbers = {'0','1','2','3','4','5','6','7','8','9'};
    std::vector<char> letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z', 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

    auto n = std::find(numbers.begin(), numbers.end(), c);
    auto l = std::find(letters.begin(), letters.end(), c);
    *l;
    if(n != numbers.end()){
        return 1;
    } else if ( l != letters.end()){
        if(edo == 4 && (*l == 'e' ||*l == 'E')){
            return 25;
        } else {
            return 0;
        }
    }

// No me deja poner el ' y el \

    switch(c){
        case ' ': return 2;
        case '+': return 3;
        case '-': return 4;
        case '*': return 5;
        case '/': return 6;
        case '<': return 7;
        case '>': return 8;
        case '=': return 9;
        case '(': return 10;
        case ')': return 11;
        case ']': return 12;
        case '[': return 13;
        case '}': return 14;
        case '{': return 15;
        case ';': return 16;
        case ',': return 17;
        case '"': return 19;
        case '#' : return 20;
        case '\n': return 22;
        case '.': return 23;
        case '_': return 26;
        case ':': return 27;
        case '|': return 28;
        default: return 24;
    }
}

int main() {
    std::vector<std::string> words = {"define", "lambda", "if", "cond", "else", "true", "false", "nil", "car", "cdr", "cons", "list", "apply", "map", "let", "begin", "null?", "eq?", "set!"};

    char c = ' ';
    std::ifstream textFile("pruebaT3 (1).txt");
    int edo = 0;

    if (textFile.is_open()){
        while (c != '$'){

            std::string word;
            textFile.get(c);
            word = "";
            while (edo < 100 && edo > -1){
                edo = MT[edo][getCol(edo, c)];
                auto reserved = std::find(words.begin(), words.end(), word); //Si ponia esto adentro marcaba error por alguna razon
                switch (edo){
                    case 100:
                        std::cout << word << "  ->Numero  " << std::endl;
                        edo = 0;
                        break;
                    case 101:
                        std::cout << word << "  ->Numero decimal  "<< std::endl;
                        edo = 0;
                        break;
                    case 102:
                        std::cout << word << "  ->Numero con e,E:  "<< std::endl;
                        break;
                    case 103:
                        if(reserved != words.end()){
                            std::cout << word << "  ->Palabra reservada  "<< std::endl;
                        } else {
                            std::cout << word << "  ->Identificador  "<< std::endl;
                        }
                        edo = 0;
                        break;
                    case 104:
                        std::cout << word << "  ->Comentario  "<< std::endl;
                        break;
                    case 120:
                        std::cout << c << "  ->Dos puntos  "<< std::endl;
                        break;
                    case 122:
                        std::cout << word << "  ->Mayor,Menor (<, >)  "<< std::endl;
                        edo = 0;
                        break;
                    case 123:
                        std::cout << c << "  ->Especiales (/,*,_)  "<< std::endl;
                        break;
                    case 124:
                        std::cout << c << "  ->Parentesis ((),[],{}) "<< std::endl;
                        break;
                    case 125:
                        std::cout << c << "  ->Punto  "<< std::endl;
                        break;
                    case 126:
                        std::cout << c << "  ->Coma  "<< std::endl;
                        break;
                    case 127:
                        std::cout << c << "  ->Comillas dobles o simples "<< std::endl;
                        break;
                    case 128:
                        std::cout << c << "  ->Gato "<< std::endl;
                        break;
                    case 129:
                        std::cout << c << "  ->Raya "<< std::endl;
                        break;
                    case 130:
                        std::cout << c << "  ->Igual "<< std::endl;
                        break;
                    case 131:
                        std::cout << c << "  ->Signo más "<< std::endl;
                        break;
                    case 132:
                        edo = 0;
                        std::cout << word << "  ->Signo menos - "<< std::endl;
                        break;
                    case 133:
                        std::cout << c << "  ->Mayor y igual  "<< std::endl;
                        break;
                    case -1:
                        break;
                    default:
                        if(c != '\n') word += c;
                        textFile.get(c);
                        break;
                }
            }
            edo = 0;
        }
        textFile.close();
    } else std::cout << "Unable to open file";


}
