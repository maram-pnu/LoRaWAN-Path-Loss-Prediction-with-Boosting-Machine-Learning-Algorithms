# LoRaWAN Path Loss Prediction with Boosting Machine Learning Algorithms

## Project Overview

This repository contains the MATLAB implementation for the models and experiments described in the research paper: **"Enhancing LoRaWAN Performance Using Boosting Machine Learning Algorithms Under Environmental Variations"**.

The primary goal of this research is to accurately predict Path Loss (PL) in Long-Range Wide-Area Networks (LoRaWAN) by incorporating environmental factors. The code evaluates five different boosting machine learning algorithms and compares their performance against traditional theoretical models.

The study demonstrates that including environmental variables—specifically barometric pressure, temperature, humidity, and particulate matter (PM2.5)—significantly improves the accuracy of path loss prediction. Among the models tested, **LightGBM** was found to offer the best trade-off between predictive accuracy and computational efficiency.

---

## The Research Paper

For a complete understanding of the methodology, experiments, and results, please refer to the full paper:

**Title:** Enhancing LoRaWAN Performance Using Boosting Machine Learning Algorithms Under Environmental Variations

**Authors:** Maram A. Alkhayyal, Almetwally M. Mostafa

**Journal:** Sensors, 2025, 25, 4101

**DOI:** [https://doi.org/10.3390/s25134101](https://doi.org/10.3390/s25134101)

---

## Dataset

This project utilizes a public dataset from a study conducted in Medellín, Colombia. The dataset is crucial as it includes not only LoRaWAN transmission parameters but also the environmental variables that are central to this research.

- **Original Dataset Source:** The dataset was provided by González-Palacio, M., et al. and is available at their [MDPI LoRaWAN Dataset GitHub repository](https://github.com/magonzalezudem/MDPI_LoRaWAN_Dataset_With_Environmental_Variables).
- **Key Features in Dataset:**
  - `rssi`, `distance`, `frequency`
  - `temperature`, `relative_humidity`, `barometric_pressure`, `PM2.5`
  - `path_loss` (target variable)

---

## Models Implemented

The MATLAB code in this repository implements and evaluates the following five boosting algorithms:

1.  **LightGBM** (Light Gradient Boosting Machine)
2.  **XGBoost** (Extreme Gradient Boosting)
3.  **AdaBoost** (Adaptive Boosting)
4.  **GentleBoost**
5.  **LogitBoost**

The models are trained to predict LoRaWAN path loss, and their performance is benchmarked using metrics such as RMSE, MAE, R², training time, and inference latency.

---

## Citation

If you use this code or the findings from our paper in your research, please cite our work:

```bibtex
@article{alkhayyal2025enhancing,
  title={Enhancing LoRaWAN Performance Using Boosting Machine Learning Algorithms Under Environmental Variations},
  author={Alkhayyal, Maram A. and Mostafa, Almetwally M.},
  journal={Sensors},
  volume={25},
  number={13},
  pages={4101},
  year={2025},
  publisher={MDPI},
  doi={10.3390/s25134101}
}
