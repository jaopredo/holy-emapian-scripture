all: temperature_converter

temperature_converter: main.o conversion.o
		g++ main.o conversion.o -o temperature_converter

main.o: main.cpp conversion.cpp
		g++ -c main.cpp -o main.o

conversion.o: conversion.cpp conversion.h
		g++ -c conversion.cpp -o conversion.o

clear:
		rm -rf *.o temperature_converter