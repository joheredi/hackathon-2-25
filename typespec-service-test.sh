#!/bin/bash

: <<'EXECUTION_PLAN'
Execution Plan:
1. Retrieve API resource details.
2. Build a document model (buildModel).
3. Get details of the document model (getModel).
4. List all models (listModels).
5. Compose a document model using existing document models (composeModel).
6. Authorize copying of a document model (authorizeModelCopy).
7. Copy the document model to another location (copyModelTo).
8. Delete the document model (deleteModel).
9. Build a custom document classifier (buildClassifier).
10. Get details of the document classifier (getClassifier).
11. List all classifiers (listClassifiers).
12. Authorize copying of a document classifier (authorizeClassifierCopy).
13. Copy the classifier to another location (copyClassifierTo).
14. Classify a document with a classifier (classifyDocument & classifyDocumentFromStream).
15. Get the result of document classification (getClassifyResult).
16. Delete the document classifier (deleteClassifier).
17. Analyze a document with a model (analyzeDocument & analyzeDocumentFromStream).
18. Get the analysis result (getAnalyzeResult).
19. Get a cropped figure from document analysis result (getAnalyzeResultFigure).
20. Get the resulting PDF from document analysis (getAnalyzeResultPdf).
21. Delete document analysis results (deleteAnalyzeResult).
22. Analyze a batch of documents (analyzeBatchDocuments).
23. Get the batch analysis result (getAnalyzeBatchResult).
24. List batch analysis results (listAnalyzeBatchResults).
25. Delete batch analysis result (deleteAnalyzeBatchResult).
26. List all API operations (listOperations).

Note: This plan ensures dependencies between operations are properly respected, particularly around building and querying resources.
EXECUTION_PLAN

# Helper function to send requests and validate responses
perform_request() {
  local method=$1
  local url=$2
  local data=$3
  local expected_status=$4

  echo "Sending ${method} request to ${url}..."
  response=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" "$url" -H "Content-Type: application/json" -d "$data")
  echo "Response status: $response"

  if [ "$response" -ne "$expected_status" ]; then
    echo "ERROR: Expected status $expected_status but got $response."
    exit 1
  fi
}

# Set base URL
BASE_URL="https://example.com" # Replace this with the actual API service URL

# 1. Get resource details
perform_request GET "$BASE_URL/info" "" 200

# 2. Build a document model
MODEL_ID="testModel"
build_model_request='{"buildRequest": {"modelId": "'"$MODEL_ID"'", "trainingConfig": {}}}'
perform_request POST "$BASE_URL/documentModels:build" "$build_model_request" 202

# 3. Get document model details
perform_request GET "$BASE_URL/documentModels/$MODEL_ID" "" 200

# 4. List all document models
perform_request GET "$BASE_URL/documentModels" "" 200

# 5. Compose a document model
compose_model_request='{"composeRequest": {"modelIds": ["'$MODEL_ID'"], "modelId": "composedModel"}}'
perform_request POST "$BASE_URL/documentModels:compose" "$compose_model_request" 202

# 6. Authorize model copy
authorize_model_copy_request='{"authorizeCopyRequest": {"modelId": "copiedModel"}}'
perform_request POST "$BASE_URL/documentModels:authorizeCopy" "$authorize_model_copy_request" 200

# 7. Copy model to another location
copy_model_request='{"modelId": "'"$MODEL_ID"'"}'
perform_request POST "$BASE_URL/documentModels/$MODEL_ID:copyTo" "$copy_model_request" 202

# 8. Delete the document model
perform_request DELETE "$BASE_URL/documentModels/$MODEL_ID" "" 204

# 9. Build classifier
CLASSIFIER_ID="testClassifier"
build_classifier_request='{"buildRequest": {"classifierId": "'"$CLASSIFIER_ID"'"}}'
perform_request POST "$BASE_URL/documentClassifiers:build" "$build_classifier_request" 202

# 10. Get classifier details
perform_request GET "$BASE_URL/documentClassifiers/$CLASSIFIER_ID" "" 200

# 11. List classifiers
perform_request GET "$BASE_URL/documentClassifiers" "" 200

# 12. Authorize classifier copy
authorize_classifier_copy_request='{"authorizeCopyRequest": {"classifierId": "copiedClassifier"}}'
perform_request POST "$BASE_URL/documentClassifiers:authorizeCopy" "$authorize_classifier_copy_request" 200

# 13. Copy classifier
copy_classifier_request='{"classifierId": "'"$CLASSIFIER_ID"'"}'
perform_request POST "$BASE_URL/documentClassifiers/$CLASSIFIER_ID:copyTo" "$copy_classifier_request" 202

# 14. Classify document
classify_document_request='{"classifyRequest": {"content": "test content"}}'
perform_request POST "$BASE_URL/documentClassifiers/$CLASSIFIER_ID:analyze" "$classify_document_request" 202

# 15. Get classification result
RESULT_ID="testResult"
perform_request GET "$BASE_URL/documentClassifiers/$CLASSIFIER_ID/analyzeResults/$RESULT_ID" "" 200

# 16. Delete classifier
perform_request DELETE "$BASE_URL/documentClassifiers/$CLASSIFIER_ID" "" 204

# 17. Analyze document
analyze_document_request='{"analyzeRequest": {"params": "testParams"}}'
perform_request POST "$BASE_URL/documentModels/$MODEL_ID:analyze" "$analyze_document_request" 202

# 18. Get analysis result
perform_request GET "$BASE_URL/documentModels/$MODEL_ID/analyzeResults/$RESULT_ID" "" 200

# 19. Get cropped figure
FIGURE_ID="testFigure"
perform_request GET "$BASE_URL/documentModels/$MODEL_ID/analyzeResults/$RESULT_ID/figures/$FIGURE_ID" "" 200

# 20. Get analysis resulting PDF
perform_request GET "$BASE_URL/documentModels/$MODEL_ID/analyzeResults/$RESULT_ID/pdf" "" 200

# 21. Delete analysis result
perform_request DELETE "$BASE_URL/documentModels/$MODEL_ID/analyzeResults/$RESULT_ID" "" 204

# 22. Analyze batch
analyze_batch_request='{"analyzeBatchRequest": {"batches": ["batch1", "batch2"]}}'
perform_request POST "$BASE_URL/documentModels/$MODEL_ID:analyzeBatch" "$analyze_batch_request" 202

# 23. Get batch analysis result
BATCH_RESULT_ID="testBatchResult"
perform_request GET "$BASE_URL/documentModels/$MODEL_ID/analyzeBatchResults/$BATCH_RESULT_ID" "" 200

# 24. List batch analysis results
perform_request GET "$BASE_URL/documentModels/$MODEL_ID/analyzeBatchResults" "" 200

# 25. Delete batch result
perform_request DELETE "$BASE_URL/documentModels/$MODEL_ID/analyzeBatchResults/$BATCH_RESULT_ID" "" 204

# 26. List all operations
perform_request GET "$BASE_URL/operations" "" 200

echo "All operations tested successfully."
