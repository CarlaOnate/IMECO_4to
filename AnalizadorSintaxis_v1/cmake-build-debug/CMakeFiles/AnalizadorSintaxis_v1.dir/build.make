# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.19

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake

# The command to remove a file.
RM = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/AnalizadorSintaxis_v1.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/AnalizadorSintaxis_v1.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/AnalizadorSintaxis_v1.dir/flags.make

CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.o: CMakeFiles/AnalizadorSintaxis_v1.dir/flags.make
CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.o: ../main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.o"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.o -c /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/main.cpp

CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/main.cpp > CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.i

CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/main.cpp -o CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.s

# Object files for target AnalizadorSintaxis_v1
AnalizadorSintaxis_v1_OBJECTS = \
"CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.o"

# External object files for target AnalizadorSintaxis_v1
AnalizadorSintaxis_v1_EXTERNAL_OBJECTS =

AnalizadorSintaxis_v1: CMakeFiles/AnalizadorSintaxis_v1.dir/main.cpp.o
AnalizadorSintaxis_v1: CMakeFiles/AnalizadorSintaxis_v1.dir/build.make
AnalizadorSintaxis_v1: CMakeFiles/AnalizadorSintaxis_v1.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable AnalizadorSintaxis_v1"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/AnalizadorSintaxis_v1.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/AnalizadorSintaxis_v1.dir/build: AnalizadorSintaxis_v1

.PHONY : CMakeFiles/AnalizadorSintaxis_v1.dir/build

CMakeFiles/AnalizadorSintaxis_v1.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/AnalizadorSintaxis_v1.dir/cmake_clean.cmake
.PHONY : CMakeFiles/AnalizadorSintaxis_v1.dir/clean

CMakeFiles/AnalizadorSintaxis_v1.dir/depend:
	cd /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1 /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1 /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/cmake-build-debug /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/cmake-build-debug /Users/carla/CLionProjects/IMECO_4to/AnalizadorSintaxis_v1/cmake-build-debug/CMakeFiles/AnalizadorSintaxis_v1.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/AnalizadorSintaxis_v1.dir/depend
