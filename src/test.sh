#!/bin/bash

export LLVM_DIR=$(brew --prefix llvm)
export PATH="$LLVM_DIR/bin:$PATH"
export LDFLAGS="-L$LLVM_DIR/lib"
export CPPFLAGS="-I$LLVM_DIR/include"
export CXX="/opt/homebrew/bin/mpicxx"

sizes=(128 256 512 1024)
threads=(1 2 3 4 5 6 7 8 9 10)
ranks=(1 2 4)

for i in {0..3}
do
    for k in {0..2}
    do
        for j in {0..9}
        do  
            export OMP_NUM_THREADS=${threads[$j]}
            echo ranks ${ranks[$k]}, core:PE=${threads[$j]} size ${sizes[$i]}
            mpirun -np ${ranks[$k]} --map-by core:PE=${threads[$j]} ./main ${sizes[$i]} ${sizes[$i]} 100 0.01
        done
        sleep 3
        python3 plotting.py
        mv output.png ./plots/out_size"${sizes[$i]}"_rank"${ranks[$k]}".png
    done
done