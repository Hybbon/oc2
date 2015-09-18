COMPILER=iverilog
TB_DIR="tb/"
BUILD_DIR="build/"

# http://stackoverflow.com/a/15066129/3508191

find $TB_DIR -type f -iname "*_tb*.v" -print0 | while IFS= read -r -d $'\0' line; do
    out=$(basename "$line");
    out="${BUILD_DIR}${out%.*}.out";
    echo "Compilando $line -> $out";
    $COMPILER -o ${out} $line;
done