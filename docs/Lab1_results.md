# Lab 1 — Experiment Results

All runs: experiment **churn-prediction** in MLflow. Base settings from `params.yaml`
(`min_samples_leaf=5`, `random_state=42`) unless changed.

| Run | model | n_estimators | max_depth | min_samples_leaf / C | f1 | recall |
|---|---|---|---|---|---|---|
| exp-01 | random_forest | 50  | 4  | leaf 5  | 0.596 | 0.778 |
| exp-02 | random_forest | 100 | 6  | leaf 5  | 0.607 | 0.791 |
| exp-03 | random_forest | 200 | 8  | leaf 5  | 0.622 | 0.781 |
| **exp-04** | **random_forest** | **300** | **12** | **leaf 5** | **0.623** | **0.754** |
| exp-05 | random_forest | 100 | 6  | leaf 1  | 0.609 | 0.783 |
| exp-06 | random_forest | 200 | 8  | leaf 10 | 0.617 | 0.783 |
| exp-07 | random_forest | 300 | 6  | leaf 20 | 0.615 | 0.799 |
| exp-08 | logistic_regression | – | – | C 0.1  | 0.606 | 0.794 |
| exp-09 | logistic_regression | – | – | C 1.0  | 0.603 | 0.802 |
| exp-10 | logistic_regression | – | – | C 10.0 | 0.603 | 0.802 |

**Chosen run: exp-04** (random_forest, n_estimators=300, max_depth=12, min_samples_leaf=5).
Reason: it has the highest F1 (0.623) of all 10 runs, so it gives the best balance between
precision and recall on the imbalanced churn target. Its recall (0.754) is still high.
These settings are now in `params.yaml → train:`.

DVC pipeline result (`dvc metrics show`): accuracy 0.7576, f1 0.6232, precision 0.5311, recall 0.754.
