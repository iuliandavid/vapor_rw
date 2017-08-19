cmake_minimum_required(VERSION 3.7)
project(hello_vapor)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES
        Sources/App/Controllers/PostController.swift
        Sources/App/Models/Post.swift
        Sources/App/main.swift
        Package.swift)

add_executable(hello_vapor ${SOURCE_FILES})