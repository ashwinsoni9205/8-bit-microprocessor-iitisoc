import subprocess
from datetime import datetime

with open("processor_result.txt","w") as finalresult: # to reset the result file
    pass

with open("instruct_all.txt","r") as instructions:
    data = instructions.read()

data = data.strip().split("\n\n") # splitted data into groups based on one blank line;
# now we need to seperate each instuction also inside this data's groups;
# This is what data is looking as of now:
# ['0000100010100110\n0000111000010010\n1001101110010000\n1011000010000000\n
#  1111100000000000\n1111100000000000\n1111100000000000\n1111100000000000\n1001101110010000\n
#  1111100000000000', '0000001011000000\n0000001111010000\n0101101101110000\n
#  1100000111000000\n0000001011000000\n0000001111010000\n0000001011000000\n0110011110100000\n
#  0110100011000000\n0000001111010000\n0000101011100000\n0000101011100000\n1111100000000000', '1000001110010000\n
#  1000011111001000\n1001101110100000\n1001111111010000\n0001111101101111\n1001001110010000\n
#  1011000100010000\n1111100000000000']

for itr in range (0,len(data)):
    final_data = data[itr].strip().splitlines() # final_data will have instructions of each group, one group in one loop cycle
    #print(final_data)

    with open("instruct.txt","w") as instruct:
        for i in range (0,len(final_data)):
            instruct.write(final_data[i])
            if(i != len(final_data)-1):
                instruct.write("\n")

    # now will execute the processor's module for each instruction group

    # compiling the testbenchfile and source file to get vvp file (compiled simulation file)
    compile_result = subprocess.run(["iverilog", "-o", "processor.vvp", "processortb.v"], capture_output=True, text=True)

    if(compile_result.returncode != 0):
        with open("processor_result.txt","a+") as resultfile:
            resultfile.write("Compilation_error \n")
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            resultfile.write(f"{timestamp}\n") # f means formatted string which tells to execute
            # expression written in {} inside an string
            resultfile.write(compile_result.stderr)
            resultfile.write("\n")
    else:
        # if no compile error then running .vvp file using vvp to get simulation results
        sim_result = subprocess.run(["vvp", "processor.vvp"],capture_output=True, text=True)        
        if(sim_result.returncode != 0):
            with open("processor_result.txt","a+") as resultfile:
                resultfile.write("Simulation_error: \n")
                timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                resultfile.write(f"{timestamp}\n")
                resultfile.write(sim_result.stderr)
                resultfile.write("\n")
        else:
            # saving the simulation results in the processor_result.txt file
            with open("processor_result.txt","a+") as resultfile:
                resultfile.write("[Simulation Output:]\n")
                timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                resultfile.write(f"{timestamp}\n")
                resultfile.write(sim_result.stdout)
                resultfile.write("\n")
    