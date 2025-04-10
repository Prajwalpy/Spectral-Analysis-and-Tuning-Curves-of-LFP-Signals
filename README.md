## Spectral Analysis and Tuning Curves of LFP Signals
## Overview
This repository contains MATLAB scripts for spectral analysis of Local Field Potential (LFP) data collected from the lateral intra-parietal cortex during directional target-reaching tasks. It includes visualization through spectrogram plots and generation of neuronal tuning curves based on spectral power.
## Data Description
The dataset comprises:
- Continuous LFP recordings across 4 channels.
- Spike time data from neurons.
- Timing information related to task-specific events (e.g., fixation onset, target appearance, and saccades).
## Key Functionalities
- Spectrogram Generation: Utilizes Chronux Toolbox's multitaper methods to visualize LFP data across various task conditions.
- Tuning Curve Construction: Computes tuning curves to evaluate neuronal activity modulation by selecting specific frequency bands and time windows.
## Repository Structure
- data/ – Contains raw LFP and timing data (.mat files).
- scripts/ – MATLAB scripts for data analysis.
- figures/ – Generated plots including spectrograms and tuning curves.

## Dependencies
- MATLAB
- Chronux Toolbox
## Contributing
Feedback and contributions are welcomed. Please submit issues, fork the project, or create pull requests to suggest improvements.
