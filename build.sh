#!/bin/bash

# Image variants
variants=(
    '5.2.2;7.3'
    '5.2.2;7.2'
    '5.2.2;7.1'
    '5.2;7.3'
    '5.2;7.2'
    '5.2;7.1'
    '5.1;7.3'
    '5.1;7.2'
    '5.1;7.1'
    '5.0;7.3'
    '5.0;7.2'
    '5.0;7.1'
    '5.0;7.0'
    '5.0;5.6'
    '4.9;7.2'
    '4.9;7.1'
    '4.9;7.0'
    '4.9;5.6'
)

build_image()
{
    IFS=';' read -ra variant <<< "$1"

    # Build tag
    tag="wp${variant[0]}-php${variant[1]}"

    # Build image
    echo "Building kidunot89/ql-events-app:${tag}"
    docker build -t kidunot89/ql-events-app:${tag} \
        --build-arg WP_VERSION=${variant[0]} \
        --build-arg PHP_VERSION=${variant[1]} \
        .
}

if [[ ! -z "$1" ]]; then
    build_image "$1"
else
    for i in "${variants[@]}"; do
        build_image "$i"
    done
fi
