import turicreate as tc

# Prepare data
data = tc.SFrame.read_json('categories_dataset_full.json')
data = data.rename({'label': 'category', 'text': 'review'})

# Split the data
training_data, test_data = data.random_split(0.8)

# Create a model
model = tc.text_classifier.create(training_data, 'category', features=['review'], max_iterations=100)

# Save predictions to an SArray
predictions = model.predict(test_data)

# Make evaluation the model
metrics = model.evaluate(test_data)
print(metrics['accuracy'])

# Save & export
model.save('CategoriesClassifier.model')
model.export_coreml('CategoriesClassifier.mlmodel')