#!/bin/sh

gen() {
    tool=$1
    output=$2
    ir=$3

    case $tool in
        default)
            docker run \
                --rm \
                --interactive \
                --attach stdin \
                --attach stdout \
                --attach stderr \
                tikz2svg \
                <input.tex \
                >output.svg
            ;;
        dvisvgm)
            docker run \
                --rm \
                --interactive \
                --attach stdin \
                --attach stdout \
                --attach stderr \
                tikz2svg \
                tikz2svg --ir $ir --tool $tool \
                <input.tex \
                >$tool-$ir.svg
            ;;
        pdftocairo)
            docker run \
                --rm \
                --interactive \
                --attach stdin \
                --attach stdout \
                --attach stderr \
                tikz2svg \
                tikz2svg --output $output --tool $tool \
                <input.tex \
                >$tool.$output
            ;;
    esac

}

gencomb() {
    gen default
    gen pdftocairo jpeg
    gen pdftocairo pdf
    gen pdftocairo png
    gen pdftocairo svg
    gen dvisvgm svg dvi
    gen dvisvgm svg pdf
}

gencomb_foreach_example() {
    cd examples

    for example in *; do
        if test -d $example; then
            cd $example

            gencomb

            cd -
        fi
    done
}
