iverilog -o ./out/fetch_testbench.vvp fetch_testbench.v
./out/fetch_testbench.vvp > ./out/fetch_test_result.csv
open ./out/fetch_test_result.csv