# CN_project_Q9_TCP_Vegas-TCP_New_Reno

This provides step-by-step instructions to successfully run and visualize simulations using NS2 (Network Simulator 2) and XGraph. The provided example includes two NS2 simulation files and utilizes XGraph for visualizing the results.

## Prerequisites
Ensure that you have the following software installed on your system:

  NS2 - Network Simulator 2 <br />
  XGraph

## Instructions
## Step 1: Install NS2
Follow the installation instructions for NS2 on your system. You can download NS2 from the official website: NS2 Download

## Step 2: Install XGraph
Install XGraph on your system. You can typically install it using your package manager or by downloading it from the official website.

## Step 3: Run NS2 Simulation Files
Run the provided NS2 simulation files using the following commands:

```
ns <filename>.tcl
```
## Step 4: Copy Generated Files to XGraph's Bin Folder
Take the generated .xg files and paste them into XGraph's bin folder.

## Step 5: Visualize Results with XGraph
Run XGraph to visualize the simulation results using the following command:

```
./xgraph vegas.xg -color blue -thickness 2 newreno.xg -color red -thickness 3 -title_x RTT_in_Seconds -title_y CWND_in_MSS
```
Adjust the color, thickness, and titles as needed for your visualization preferences.

## Additional Notes
Ensure that you have the necessary permissions to execute the files and that the paths are correctly set.
Customize the XGraph command parameters based on your specific visualization requirements.
Feel free to reach out if you encounter any issues or have questions. Happy simulating!
