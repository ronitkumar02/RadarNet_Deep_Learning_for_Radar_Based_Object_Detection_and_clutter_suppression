# RadarNet: Deep Learning for Radar-Based Object Detection

RadarNet is a project dedicated to developing a robust deep neural network using MATLAB for object detection from radar-captured images. Leveraging the unique capabilities of radar sensing and the power of deep learning, our primary objective is to significantly enhance object detection accuracy and reliability in real-world scenarios.

## Key Objectives:

1. **Enhanced Detection Accuracy**: By harnessing the strengths of radar technology and deep learning algorithms, RadarNet aims to achieve superior detection accuracy compared to traditional methods.

2. **Real-World Reliability**: Our neural network is designed to excel in real-world conditions, where factors like weather, lighting, and object complexity can significantly impact detection performance.

3. **Curated Datasets**: We are generating meticulously curated datasets for training, testing, and validation purposes. These datasets ensure that our neural network is trained on diverse and representative examples, leading to robust and generalizable detection capabilities.

4. **Efficient Information Extraction**: RadarNet focuses on designing a neural network architecture capable of effectively extracting meaningful information from raw radar data. This ensures that our system can accurately detect and classify objects of interest with high precision.

## Contributions:

- **Advancing Radar-Based Object Detection**: By integrating radar technology with state-of-the-art deep learning techniques, RadarNet contributes to the advancement of object detection methods, particularly in the domain of radar sensing.

- **Enabling Safer Autonomous Systems**: Our ultimate goal is to empower autonomous systems with safer and more intelligent object detection capabilities. RadarNet plays a crucial role in enhancing the perception abilities of autonomous vehicles and other unmanned systems, leading to increased safety and reliability.

## Toolkit Used:
- RADAR TOOLKIT
- DEEP LEARNING TOOLKIT
- IMAGE PROCESSING TOOLKIT
## How to Use:

### Training the Model:
1. Navigate to the Radar dataset generator and execute `clutter_dataset.m` to generate the dataset.
2. Split the dataset images (Clutter and noClutter) into train, validation, and test sets. Alternatively, utilize the pre-generated dataset, "Radar dataset".
3. Run `Radar_dnn.mlx` to train the model.

### Using the Pre-trained Model:
We have provided a pre-trained model for immediate use.
To utilize the pre-trained model:
1. Load the pre-trained model.
2. Input the radar image(s) of interest.
3. Examine the results.

Feel free to experiment with different radar images and configurations to observe the model's performance.
 


**Keywords**: Radar, Object Detection, Deep Learning, MATLAB, Autonomous Systems
