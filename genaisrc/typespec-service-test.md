---
title: TypeSpec Driven Service Validation
sidebar:
  order: 100
description: Automatically generate a validation script using Copilot to ensure
  a service's implementation matches its TypeSpec spec. A language-agnostic test
  to help service developers catch spec inconsistencies early.
keywords: TypeSpec, AI, Test
model: github:gpt-4o
---

---

Automatically generate a validation script using Copilot to ensure
a service's implementation matches its TypeSpec spec. A language-agnostic test
to help service developers catch spec inconsistencies early.

### Operation Discovery

**Goal:** See if we can make copilot reliably identify all the operations available through the API.

**Challenges:** Many specs use Templates which create indirection that might make it hard for copilot to reason about.

**Prompt:**

```js
script({ files: "DocumentInteligence/routes.tsp" });

def("ROUTES", env.files);
$`You are an expert REST API architect and developer.
Review the TypeSpec service definition in ROUTES and identify all operations available through the API. List them by name and HTTP verb. `;
```

<!-- genaiscript output start -->

<details>
<summary>👤 user</summary>

```md
<ROUTES lang="tsp" file="DocumentInteligence/routes.tsp">
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-client-generator-core";
import "@typespec/rest";
import "@typespec/http";
import "./models.tsp";

using Azure.Core;
using Azure.Core.Traits;
using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.ClientGenerator.Core;

namespace DocumentIntelligence;

alias ServiceTraits = NoConditionalRequests &
NoRepeatableRequests &
SupportsClientRequestId;

op DocumentIntelligenceOperation<
TParams extends TypeSpec.Reflection.Model,
TResponse extends TypeSpec.Reflection.Model & Foundations.RetryAfterHeader

> is Foundations.Operation<
> TParams,
> TResponse,
> ServiceTraits,
> DocumentIntelligenceErrorResponse
> ;

alias DIResourceOperations = ResourceOperations<
ServiceTraits,
DocumentIntelligenceErrorResponse

> ;

#suppress "@azure-tools/typespec-azure-core/long-running-polling-operation-required" "This is a template"
op DocumentIntelligenceLongRunningOperation<
TParams extends TypeSpec.Reflection.Model,
TResponse extends TypeSpec.Reflection.Model

> is Foundations.Operation<
> TParams,
> AcceptedResponse &

    Foundations.RetryAfterHeader & {
      @pollingLocation
      @header("Operation-Location")
      operationLocation: ResourceLocation<TResponse>;
    },

ServiceTraits,
DocumentIntelligenceErrorResponse

> ;

@doc("Document model analyze request parameters.")
model DocumentModelAnalyzeRequestParams {
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

@doc("1-based page numbers to analyze. Ex. \"1-3,5,7-9\"")
@query
@pattern("^(\\d+(-\\d+)?)(,\\s*(\\d+(-\\d+)?))*$")
pages?: string;

@doc("""
Locale hint for text recognition and document analysis. Value may contain only
the language code (ex. \"en\", \"fr\") or BCP 47 language tag (ex. \"en-US\").
""")
@query
locale?: string;

@doc("Method used to compute string offset and length.")
@query
stringIndexType?: StringIndexType = StringIndexType.textElements;

@doc("List of optional analysis features.")
@query
features?: DocumentAnalysisFeature[];

@doc("List of additional fields to extract. Ex. \"NumberOfGuests,StoreNumber\"")
@query
queryFields?: string[];

@doc("Format of the analyze result top-level content.")
@query
outputContentFormat?: DocumentContentFormat = DocumentContentFormat.text;

@doc("Additional outputs to generate during analysis.")
@query
output?: AnalyzeOutputOption[];
}

@doc("Document classifier analyze request parameters.")
model DocumentClassifierAnalyzeRequestParams {
@doc("Unique document classifier name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
classifierId: string;

@doc("Method used to compute string offset and length.")
@query
stringIndexType?: StringIndexType = StringIndexType.textElements;

@doc("Document splitting mode.")
@query
split?: SplitMode = SplitMode.none;

@doc("1-based page numbers to analyze. Ex. \"1-3,5,7-9\"")
@query
@pattern("^(\\d+(-\\d+)?)(,\\s*(\\d+(-\\d+)?))*$")
pages?: string;
}

@doc("Analyze from stream request parameters.")
model AnalyzeFromStreamRequestParams {
#suppress "@azure-tools/typespec-azure-core/no-closed-literal-union" "This union cannot be open"
@doc("Input content type.")
@header
contentType:
| "application/octet-stream"
| "application/pdf"
| "image/jpeg"
| "image/png"
| "image/tiff"
| "image/bmp"
| "image/heif"
| "text/html"
| "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
| "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
| "application/vnd.openxmlformats-officedocument.presentationml.presentation";

@doc("Input content.")
@bodyRoot
input: bytes;
}

interface DocumentModels {
#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the result of document analysis.")
@route("/documentModels/{modelId}/analyzeResults/{resultId}")
@get
getAnalyzeResult is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;
    },
    AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the generated searchable PDF output from document analysis.")
@route("/documentModels/{modelId}/analyzeResults/{resultId}/pdf")
@get
getAnalyzeResultPdf is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;
    },
    {
      @doc("Response content type.")
      @header
      contentType: "application/pdf";

      @doc("Response PDF.")
      @body
      pdf: bytes;
    }

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the generated cropped image of specified figure from document analysis.")
@route("/documentModels/{modelId}/analyzeResults/{resultId}/figures/{figureId}")
@get
getAnalyzeResultFigure is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;

      @doc("Figure ID.")
      @path
      figureId: string;
    },
    {
      @doc("Response content type.")
      @header
      contentType: "image/png";

      @doc("Response image.")
      @body
      image: bytes;
    }

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Mark the result of document analysis for deletion.")
@route("/documentModels/{modelId}/analyzeResults/{resultId}")
@delete
deleteAnalyzeResult is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;
    },
    TypeSpec.Http.NoContentResponse

> ;

#suppress "@azure-tools/typespec-azure-core/byos" "Support uploading input files"
#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Analyzes document with document model.")
@post
@pollingOperation(DocumentModels.getAnalyzeResult)
@sharedRoute
@route("/documentModels/{modelId}:analyze")
analyzeDocumentFromStream is DocumentIntelligenceLongRunningOperation<
{
...DocumentModelAnalyzeRequestParams;
...AnalyzeFromStreamRequestParams;
},
AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Analyzes document with document model.")
@post
@pollingOperation(DocumentModels.getAnalyzeResult)
@sharedRoute
@route("/documentModels/{modelId}:analyze")
analyzeDocument is DocumentIntelligenceLongRunningOperation<
{
...DocumentModelAnalyzeRequestParams;

      @doc("Input content type.")
      @header
      contentType: "application/json";

      @doc("Analyze request parameters.")
      @bodyRoot
      @clientName("body", "python")
      analyzeRequest: AnalyzeDocumentRequest;
    },
    AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the result of batch document analysis.")
@route("/documentModels/{modelId}/analyzeBatchResults/{resultId}")
@get
getAnalyzeBatchResult is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze batch operation result ID.")
      @path
      resultId: uuid;
    },
    AnalyzeBatchOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Analyzes batch documents with document model.")
@post
@pollingOperation(DocumentModels.getAnalyzeBatchResult)
@route("/documentModels/{modelId}:analyzeBatch")
analyzeBatchDocuments is DocumentIntelligenceLongRunningOperation<
{
...DocumentModelAnalyzeRequestParams;

      @doc("Input content type")
      @header
      contentType: "application/json";

      @doc("Analyze batch request parameters.")
      @body
      @clientName("body", "python")
      analyzeBatchRequest: AnalyzeBatchDocumentsRequest;
    },
    AnalyzeBatchOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("List batch document analysis results.")
@route("/documentModels/{modelId}/analyzeBatchResults")
@get
listAnalyzeBatchResults is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;
},
Foundations.CustomPage<AnalyzeBatchOperation>

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Mark the batch document analysis result for deletion.")
@route("/documentModels/{modelId}/analyzeBatchResults/{resultId}")
@delete
deleteAnalyzeBatchResult is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze batch operation result ID.")
      @path
      resultId: uuid;
    },
    NoContentResponse

> ;

@doc("Gets detailed document model information.")
getModel is DIResourceOperations.ResourceRead<DocumentModelDetails>;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Builds a custom document analysis model.")
@pollingOperation(MiscellaneousOperations.getDocumentModelBuildOperation)
@route("/documentModels:build")
@post
buildModel is DocumentIntelligenceLongRunningOperation<
{
@doc("Build request parameters.")
@bodyRoot
@clientName("body", "python")
buildRequest: BuildDocumentModelRequest;
},
DocumentModelBuildOperationDetails

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Creates a new document model from document types of existing document models.")
@pollingOperation(MiscellaneousOperations.getDocumentModelComposeOperation)
@route("/documentModels:compose")
@post
composeModel is DocumentIntelligenceLongRunningOperation<
{
@doc("Compose request parameters.")
@bodyRoot
@clientName("body", "python")
composeRequest: ComposeDocumentModelRequest;
},
DocumentModelComposeOperationDetails

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("""
Generates authorization to copy a document model to this location with
specified modelId and optional description.
""")
@route("/documentModels:authorizeCopy")
@post
authorizeModelCopy is DocumentIntelligenceOperation<
{
@doc("Authorize copy request parameters.")
@bodyRoot
@clientName("body", "python")
authorizeCopyRequest: AuthorizeCopyRequest;
},
ModelCopyAuthorization

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Copies document model to the target resource, region, and modelId.")
@pollingOperation(MiscellaneousOperations.getDocumentModelCopyToOperation)
@route("/documentModels/{modelId}:copyTo")
@post
copyModelTo is DocumentIntelligenceLongRunningOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Copy to request parameters.")
      @bodyRoot
      @clientName("body", "python")
      copyToRequest: ModelCopyAuthorization;
    },
    DocumentModelCopyToOperationDetails

> ;

@doc("List all document models")
listModels is DIResourceOperations.ResourceList<DocumentModelDetails>;

@doc("Deletes document model.")
@delete
deleteModel is DIResourceOperations.ResourceDelete<DocumentModelDetails>;
}

interface MiscellaneousOperations {
@doc("Lists all operations.")
listOperations is DIResourceOperations.ResourceList<DocumentIntelligenceOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentModelBuildOperation is DIResourceOperations.ResourceRead<DocumentModelBuildOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentModelComposeOperation is DIResourceOperations.ResourceRead<DocumentModelComposeOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentModelCopyToOperation is DIResourceOperations.ResourceRead<DocumentModelCopyToOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentClassifierCopyToOperation is DIResourceOperations.ResourceRead<DocumentClassifierCopyToOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentClassifierBuildOperation is DIResourceOperations.ResourceRead<DocumentClassifierBuildOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getOperation is DIResourceOperations.ResourceRead<DocumentIntelligenceOperationDetails>;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Return information about the current resource.")
@route("/info")
@get
getResourceDetails is DocumentIntelligenceOperation<
{},
DocumentIntelligenceResourceDetails

> ;
> }

interface DocumentClassifiers {
#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Builds a custom document classifier.")
@pollingOperation(MiscellaneousOperations.getDocumentClassifierBuildOperation)
@route("/documentClassifiers:build")
@post
buildClassifier is DocumentIntelligenceLongRunningOperation<
{
@doc("Build request parameters.")
@bodyRoot
@clientName("body", "python")
buildRequest: BuildDocumentClassifierRequest;
},
DocumentClassifierBuildOperationDetails

> ;

@doc("List all document classifiers.")
listClassifiers is DIResourceOperations.ResourceList<DocumentClassifierDetails>;

@doc("Gets detailed document classifier information.")
getClassifier is DIResourceOperations.ResourceRead<DocumentClassifierDetails>;

@doc("Deletes document classifier.")
deleteClassifier is DIResourceOperations.ResourceDelete<DocumentClassifierDetails>;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
#suppress "@azure-tools/typespec-azure-core/byos" "Support uploading input files"
@doc("Classifies document with document classifier.")
@pollingOperation(DocumentClassifiers.getClassifyResult)
@sharedRoute
@route("/documentClassifiers/{classifierId}:analyze")
@post
classifyDocumentFromStream is DocumentIntelligenceLongRunningOperation<
{
...DocumentClassifierAnalyzeRequestParams;
...AnalyzeFromStreamRequestParams;
},
AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Classifies document with document classifier.")
@pollingOperation(DocumentClassifiers.getClassifyResult)
@sharedRoute
@route("/documentClassifiers/{classifierId}:analyze")
@post
classifyDocument is DocumentIntelligenceLongRunningOperation<
{
...DocumentClassifierAnalyzeRequestParams;

      @doc("Input content type")
      @header
      contentType: "application/json";

      @doc("Classify request parameters.")
      @bodyRoot
      @clientName("body", "python")
      classifyRequest: ClassifyDocumentRequest;
    },
    AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the result of document classifier.")
@route("/documentClassifiers/{classifierId}/analyzeResults/{resultId}")
@get
getClassifyResult is DocumentIntelligenceOperation<
{
@doc("Unique document classifier name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
classifierId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;
    },
    AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("""
Generates authorization to copy a document classifier to this location with
specified classifierId and optional description.
""")
@route("/documentClassifiers:authorizeCopy")
@post
authorizeClassifierCopy is DocumentIntelligenceOperation<
{
@doc("Authorize copy request parameters.")
@body
@clientName("body", "python")
authorizeCopyRequest: AuthorizeClassifierCopyRequest;
},
ClassifierCopyAuthorization

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Copies document classifier to the target resource, region, and classifierId.")
@pollingOperation(
MiscellaneousOperations.getDocumentClassifierCopyToOperation
)
@route("/documentClassifiers/{classifierId}:copyTo")
@post
copyClassifierTo is DocumentIntelligenceLongRunningOperation<
{
@doc("Unique document classifier name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
classifierId: string;

      @doc("Copy to request parameters.")
      @body
      @clientName("body", "python")
      copyToRequest: ClassifierCopyAuthorization;
    },
    DocumentClassifierCopyToOperationDetails

> ;
> }
> </ROUTES>

You are an expert REST API architect and developer.
Review the TypeSpec service definition in ROUTES and identify all operations available through the API. List them by name and HTTP verb.
```

</details>

<details open>
<summary>🤖 assistant </summary>

```md
Here is a list of operations available in the API, organized by their names and HTTP verbs:

### **Document Models**

1. **GET**

   - `getAnalyzeResult`
   - `getAnalyzeResultPdf`
   - `getAnalyzeResultFigure`
   - `getAnalyzeBatchResult`
   - `listAnalyzeBatchResults`
   - `getModel`
   - `listModels`

2. **POST**

   - `analyzeDocumentFromStream`
   - `analyzeDocument`
   - `analyzeBatchDocuments`
   - `buildModel`
   - `composeModel`
   - `authorizeModelCopy`
   - `copyModelTo`

3. **DELETE**
   - `deleteAnalyzeResult`
   - `deleteAnalyzeBatchResult`
   - `deleteModel`

---

### **Miscellaneous Operations**

1. **GET**
   - `listOperations`
   - `getDocumentModelBuildOperation`
   - `getDocumentModelComposeOperation`
   - `getDocumentModelCopyToOperation`
   - `getDocumentClassifierCopyToOperation`
   - `getDocumentClassifierBuildOperation`
   - `getOperation`
   - `getResourceDetails`

---

### **Document Classifiers**

1. **GET**

   - `listClassifiers`
   - `getClassifier`
   - `getClassifyResult`

2. **POST**

   - `buildClassifier`
   - `classifyDocumentFromStream`
   - `classifyDocument`
   - `authorizeClassifierCopy`
   - `copyClassifierTo`

3. **DELETE**
   - `deleteClassifier`
```

</details>

<!-- genaiscript output end -->

**Notes:**

- Can't pass the whole spec because it exceeds the body size limit
- Seems to have discovered the operations correctly, however the test spec defines all operations verbose doesn't use Resource templates.

### Operation Dependency inference

**Goal:** see if copilot can identify if and which operations need to be run in order and propose an execution plan.

**Prompt**

```js
script({ files: "DocumentInteligence/routes.tsp" });

def("ROUTES", env.files);
$`You are an expert REST API architect and developer.
Review the TypeSpec service definition in ROUTES and identify all operations available through the API.
We want to test all the operations defined in the service to make sure that the TypeSpec represents the service API correctly.
Some operations would require other operations to be run before they can run. For example, querying a resource needs to make sure that the operation for creating that resource
has completed and successfully executed.

Write an execution plan that shows in which operations will be executed in which order and note any dependencies and defendants each operation have.`;
```

<!-- genaiscript output start -->

<details>
<summary>👤 user</summary>

```md
<ROUTES lang="tsp" file="DocumentInteligence/routes.tsp">
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-client-generator-core";
import "@typespec/rest";
import "@typespec/http";
import "./models.tsp";

using Azure.Core;
using Azure.Core.Traits;
using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.ClientGenerator.Core;

namespace DocumentIntelligence;

alias ServiceTraits = NoConditionalRequests &
NoRepeatableRequests &
SupportsClientRequestId;

op DocumentIntelligenceOperation<
TParams extends TypeSpec.Reflection.Model,
TResponse extends TypeSpec.Reflection.Model & Foundations.RetryAfterHeader

> is Foundations.Operation<
> TParams,
> TResponse,
> ServiceTraits,
> DocumentIntelligenceErrorResponse
> ;

alias DIResourceOperations = ResourceOperations<
ServiceTraits,
DocumentIntelligenceErrorResponse

> ;

#suppress "@azure-tools/typespec-azure-core/long-running-polling-operation-required" "This is a template"
op DocumentIntelligenceLongRunningOperation<
TParams extends TypeSpec.Reflection.Model,
TResponse extends TypeSpec.Reflection.Model

> is Foundations.Operation<
> TParams,
> AcceptedResponse &

    Foundations.RetryAfterHeader & {
      @pollingLocation
      @header("Operation-Location")
      operationLocation: ResourceLocation<TResponse>;
    },

ServiceTraits,
DocumentIntelligenceErrorResponse

> ;

@doc("Document model analyze request parameters.")
model DocumentModelAnalyzeRequestParams {
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

@doc("1-based page numbers to analyze. Ex. \"1-3,5,7-9\"")
@query
@pattern("^(\\d+(-\\d+)?)(,\\s*(\\d+(-\\d+)?))*$")
pages?: string;

@doc("""
Locale hint for text recognition and document analysis. Value may contain only
the language code (ex. \"en\", \"fr\") or BCP 47 language tag (ex. \"en-US\").
""")
@query
locale?: string;

@doc("Method used to compute string offset and length.")
@query
stringIndexType?: StringIndexType = StringIndexType.textElements;

@doc("List of optional analysis features.")
@query
features?: DocumentAnalysisFeature[];

@doc("List of additional fields to extract. Ex. \"NumberOfGuests,StoreNumber\"")
@query
queryFields?: string[];

@doc("Format of the analyze result top-level content.")
@query
outputContentFormat?: DocumentContentFormat = DocumentContentFormat.text;

@doc("Additional outputs to generate during analysis.")
@query
output?: AnalyzeOutputOption[];
}

@doc("Document classifier analyze request parameters.")
model DocumentClassifierAnalyzeRequestParams {
@doc("Unique document classifier name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
classifierId: string;

@doc("Method used to compute string offset and length.")
@query
stringIndexType?: StringIndexType = StringIndexType.textElements;

@doc("Document splitting mode.")
@query
split?: SplitMode = SplitMode.none;

@doc("1-based page numbers to analyze. Ex. \"1-3,5,7-9\"")
@query
@pattern("^(\\d+(-\\d+)?)(,\\s*(\\d+(-\\d+)?))*$")
pages?: string;
}

@doc("Analyze from stream request parameters.")
model AnalyzeFromStreamRequestParams {
#suppress "@azure-tools/typespec-azure-core/no-closed-literal-union" "This union cannot be open"
@doc("Input content type.")
@header
contentType:
| "application/octet-stream"
| "application/pdf"
| "image/jpeg"
| "image/png"
| "image/tiff"
| "image/bmp"
| "image/heif"
| "text/html"
| "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
| "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
| "application/vnd.openxmlformats-officedocument.presentationml.presentation";

@doc("Input content.")
@bodyRoot
input: bytes;
}

interface DocumentModels {
#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the result of document analysis.")
@route("/documentModels/{modelId}/analyzeResults/{resultId}")
@get
getAnalyzeResult is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;
    },
    AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the generated searchable PDF output from document analysis.")
@route("/documentModels/{modelId}/analyzeResults/{resultId}/pdf")
@get
getAnalyzeResultPdf is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;
    },
    {
      @doc("Response content type.")
      @header
      contentType: "application/pdf";

      @doc("Response PDF.")
      @body
      pdf: bytes;
    }

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the generated cropped image of specified figure from document analysis.")
@route("/documentModels/{modelId}/analyzeResults/{resultId}/figures/{figureId}")
@get
getAnalyzeResultFigure is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;

      @doc("Figure ID.")
      @path
      figureId: string;
    },
    {
      @doc("Response content type.")
      @header
      contentType: "image/png";

      @doc("Response image.")
      @body
      image: bytes;
    }

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Mark the result of document analysis for deletion.")
@route("/documentModels/{modelId}/analyzeResults/{resultId}")
@delete
deleteAnalyzeResult is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;
    },
    TypeSpec.Http.NoContentResponse

> ;

#suppress "@azure-tools/typespec-azure-core/byos" "Support uploading input files"
#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Analyzes document with document model.")
@post
@pollingOperation(DocumentModels.getAnalyzeResult)
@sharedRoute
@route("/documentModels/{modelId}:analyze")
analyzeDocumentFromStream is DocumentIntelligenceLongRunningOperation<
{
...DocumentModelAnalyzeRequestParams;
...AnalyzeFromStreamRequestParams;
},
AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Analyzes document with document model.")
@post
@pollingOperation(DocumentModels.getAnalyzeResult)
@sharedRoute
@route("/documentModels/{modelId}:analyze")
analyzeDocument is DocumentIntelligenceLongRunningOperation<
{
...DocumentModelAnalyzeRequestParams;

      @doc("Input content type.")
      @header
      contentType: "application/json";

      @doc("Analyze request parameters.")
      @bodyRoot
      @clientName("body", "python")
      analyzeRequest: AnalyzeDocumentRequest;
    },
    AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the result of batch document analysis.")
@route("/documentModels/{modelId}/analyzeBatchResults/{resultId}")
@get
getAnalyzeBatchResult is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze batch operation result ID.")
      @path
      resultId: uuid;
    },
    AnalyzeBatchOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Analyzes batch documents with document model.")
@post
@pollingOperation(DocumentModels.getAnalyzeBatchResult)
@route("/documentModels/{modelId}:analyzeBatch")
analyzeBatchDocuments is DocumentIntelligenceLongRunningOperation<
{
...DocumentModelAnalyzeRequestParams;

      @doc("Input content type")
      @header
      contentType: "application/json";

      @doc("Analyze batch request parameters.")
      @body
      @clientName("body", "python")
      analyzeBatchRequest: AnalyzeBatchDocumentsRequest;
    },
    AnalyzeBatchOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("List batch document analysis results.")
@route("/documentModels/{modelId}/analyzeBatchResults")
@get
listAnalyzeBatchResults is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;
},
Foundations.CustomPage<AnalyzeBatchOperation>

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Mark the batch document analysis result for deletion.")
@route("/documentModels/{modelId}/analyzeBatchResults/{resultId}")
@delete
deleteAnalyzeBatchResult is DocumentIntelligenceOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Analyze batch operation result ID.")
      @path
      resultId: uuid;
    },
    NoContentResponse

> ;

@doc("Gets detailed document model information.")
getModel is DIResourceOperations.ResourceRead<DocumentModelDetails>;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Builds a custom document analysis model.")
@pollingOperation(MiscellaneousOperations.getDocumentModelBuildOperation)
@route("/documentModels:build")
@post
buildModel is DocumentIntelligenceLongRunningOperation<
{
@doc("Build request parameters.")
@bodyRoot
@clientName("body", "python")
buildRequest: BuildDocumentModelRequest;
},
DocumentModelBuildOperationDetails

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Creates a new document model from document types of existing document models.")
@pollingOperation(MiscellaneousOperations.getDocumentModelComposeOperation)
@route("/documentModels:compose")
@post
composeModel is DocumentIntelligenceLongRunningOperation<
{
@doc("Compose request parameters.")
@bodyRoot
@clientName("body", "python")
composeRequest: ComposeDocumentModelRequest;
},
DocumentModelComposeOperationDetails

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("""
Generates authorization to copy a document model to this location with
specified modelId and optional description.
""")
@route("/documentModels:authorizeCopy")
@post
authorizeModelCopy is DocumentIntelligenceOperation<
{
@doc("Authorize copy request parameters.")
@bodyRoot
@clientName("body", "python")
authorizeCopyRequest: AuthorizeCopyRequest;
},
ModelCopyAuthorization

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Copies document model to the target resource, region, and modelId.")
@pollingOperation(MiscellaneousOperations.getDocumentModelCopyToOperation)
@route("/documentModels/{modelId}:copyTo")
@post
copyModelTo is DocumentIntelligenceLongRunningOperation<
{
@doc("Unique document model name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
modelId: string;

      @doc("Copy to request parameters.")
      @bodyRoot
      @clientName("body", "python")
      copyToRequest: ModelCopyAuthorization;
    },
    DocumentModelCopyToOperationDetails

> ;

@doc("List all document models")
listModels is DIResourceOperations.ResourceList<DocumentModelDetails>;

@doc("Deletes document model.")
@delete
deleteModel is DIResourceOperations.ResourceDelete<DocumentModelDetails>;
}

interface MiscellaneousOperations {
@doc("Lists all operations.")
listOperations is DIResourceOperations.ResourceList<DocumentIntelligenceOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentModelBuildOperation is DIResourceOperations.ResourceRead<DocumentModelBuildOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentModelComposeOperation is DIResourceOperations.ResourceRead<DocumentModelComposeOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentModelCopyToOperation is DIResourceOperations.ResourceRead<DocumentModelCopyToOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentClassifierCopyToOperation is DIResourceOperations.ResourceRead<DocumentClassifierCopyToOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getDocumentClassifierBuildOperation is DIResourceOperations.ResourceRead<DocumentClassifierBuildOperationDetails>;

@sharedRoute
@doc("Gets operation info.")
getOperation is DIResourceOperations.ResourceRead<DocumentIntelligenceOperationDetails>;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Return information about the current resource.")
@route("/info")
@get
getResourceDetails is DocumentIntelligenceOperation<
{},
DocumentIntelligenceResourceDetails

> ;
> }

interface DocumentClassifiers {
#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Builds a custom document classifier.")
@pollingOperation(MiscellaneousOperations.getDocumentClassifierBuildOperation)
@route("/documentClassifiers:build")
@post
buildClassifier is DocumentIntelligenceLongRunningOperation<
{
@doc("Build request parameters.")
@bodyRoot
@clientName("body", "python")
buildRequest: BuildDocumentClassifierRequest;
},
DocumentClassifierBuildOperationDetails

> ;

@doc("List all document classifiers.")
listClassifiers is DIResourceOperations.ResourceList<DocumentClassifierDetails>;

@doc("Gets detailed document classifier information.")
getClassifier is DIResourceOperations.ResourceRead<DocumentClassifierDetails>;

@doc("Deletes document classifier.")
deleteClassifier is DIResourceOperations.ResourceDelete<DocumentClassifierDetails>;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
#suppress "@azure-tools/typespec-azure-core/byos" "Support uploading input files"
@doc("Classifies document with document classifier.")
@pollingOperation(DocumentClassifiers.getClassifyResult)
@sharedRoute
@route("/documentClassifiers/{classifierId}:analyze")
@post
classifyDocumentFromStream is DocumentIntelligenceLongRunningOperation<
{
...DocumentClassifierAnalyzeRequestParams;
...AnalyzeFromStreamRequestParams;
},
AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Classifies document with document classifier.")
@pollingOperation(DocumentClassifiers.getClassifyResult)
@sharedRoute
@route("/documentClassifiers/{classifierId}:analyze")
@post
classifyDocument is DocumentIntelligenceLongRunningOperation<
{
...DocumentClassifierAnalyzeRequestParams;

      @doc("Input content type")
      @header
      contentType: "application/json";

      @doc("Classify request parameters.")
      @bodyRoot
      @clientName("body", "python")
      classifyRequest: ClassifyDocumentRequest;
    },
    AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Gets the result of document classifier.")
@route("/documentClassifiers/{classifierId}/analyzeResults/{resultId}")
@get
getClassifyResult is DocumentIntelligenceOperation<
{
@doc("Unique document classifier name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
classifierId: string;

      @doc("Analyze operation result ID.")
      @path
      resultId: uuid;
    },
    AnalyzeOperation

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("""
Generates authorization to copy a document classifier to this location with
specified classifierId and optional description.
""")
@route("/documentClassifiers:authorizeCopy")
@post
authorizeClassifierCopy is DocumentIntelligenceOperation<
{
@doc("Authorize copy request parameters.")
@body
@clientName("body", "python")
authorizeCopyRequest: AuthorizeClassifierCopyRequest;
},
ClassifierCopyAuthorization

> ;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Doesn't fit standard ops"
@doc("Copies document classifier to the target resource, region, and classifierId.")
@pollingOperation(
MiscellaneousOperations.getDocumentClassifierCopyToOperation
)
@route("/documentClassifiers/{classifierId}:copyTo")
@post
copyClassifierTo is DocumentIntelligenceLongRunningOperation<
{
@doc("Unique document classifier name.")
@path
@pattern("^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$")
@maxLength(64)
classifierId: string;

      @doc("Copy to request parameters.")
      @body
      @clientName("body", "python")
      copyToRequest: ClassifierCopyAuthorization;
    },
    DocumentClassifierCopyToOperationDetails

> ;
> }
> </ROUTES>

You are an expert REST API architect and developer.
Review the TypeSpec service definition in ROUTES and identify all operations available through the API.
We want to test all the operations defined in the service to make sure that the TypeSpec represents the service API correctly.
Some operations would require other operations to be run before they can run. For example, querying a resource needs to make sure that the operation for creating that resource
has completed and successfully executed.

Write an execution plan that shows in which operations will be executed in which order and note any dependencies and defendants each operation have.
```

</details>

<details open>
<summary>🤖 assistant </summary>

```md
### Execution Plan for DocumentIntelligence API

Below is the organized execution plan, highlighting **dependencies**, and which operations must be executed **before** others to ensure proper testing of the API. The plan assumes a clean slate (no pre-existing resources) and covers all operations defined in the TypeSpec.

#### **Document Models Operations**

1. **`listModels`**

   - **Purpose**: Lists all document models in the account.
   - **Dependencies**: None.
   - **Notes**: Initial operation to baseline state before creating models.

2. **`buildModel`**

   - **Purpose**: Builds a custom document analysis model.
   - **Dependencies**: None.
   - **Notes**: This must be tested before retrieving the model or using it in analysis.

3. **`getModel`**

   - **Purpose**: Retrieves detailed information of a specific model.
   - **Dependencies**: Requires `buildModel` to have successfully created a model.

4. **`composeModel`**

   - **Purpose**: Composes a new document model from types of existing models.
   - **Dependencies**: Requires at least two models created via `buildModel`.

5. **`deleteModel`**

   - **Purpose**: Deletes a specific document model.
   - **Dependencies**: None, but typically executed after testing analysis operations.
   - **Notes**: Make sure no dependent operations (e.g., analyze) are pending for deletion.

6. **`authorizeModelCopy`**

   - **Purpose**: Generates authorization info for copying a document model.
   - **Dependencies**: Requires an existing model (`buildModel`).

7. **`copyModelTo`**
   - **Purpose**: Copies a document model to a destination account/region.
   - **Dependencies**: Requires authorization from `authorizeModelCopy`.

---

#### **Document Analysis Operations**

8. **`analyzeDocumentFromStream`**

   - **Purpose**: Analyzes a document using a model via raw stream input.
   - **Dependencies**: Requires an existing document model (`buildModel`).
   - **Notes**: Must follow up with `getAnalyzeResult`.

9. **`analyzeDocument`**

   - **Purpose**: Analyzes a document using a model via JSON input.
   - **Dependencies**: Requires an existing document model (`buildModel`).
   - **Notes**: Must follow up with `getAnalyzeResult`.

10. **`getAnalyzeResult`**

    - **Purpose**: Retrieves results for a previously submitted document analysis.
    - **Dependencies**: Requires `analyzeDocumentFromStream` or `analyzeDocument`.

11. **`getAnalyzeResultPdf`**

    - **Purpose**: Retrieves the searchable PDF result of the document analysis.
    - **Dependencies**: Requires `analyzeDocumentFromStream` or `analyzeDocument`.

12. **`getAnalyzeResultFigure`**

    - **Purpose**: Retrieves cropped images of specific figures from the analysis.
    - **Dependencies**: Requires `analyzeDocumentFromStream` or `analyzeDocument`.

13. **`deleteAnalyzeResult`**
    - **Purpose**: Deletes analysis results for cleanup.
    - **Dependencies**: Requires `getAnalyzeResult`.

---

#### **Batch Document Analysis Operations**

14. **`analyzeBatchDocuments`**

    - **Purpose**: Analyzes multiple documents in a batch.
    - **Dependencies**: Requires an existing document model (`buildModel`).
    - **Notes**: Must follow up with `getAnalyzeBatchResult`.

15. **`getAnalyzeBatchResult`**

    - **Purpose**: Retrieves results for a previously submitted batch document analysis.
    - **Dependencies**: Requires `analyzeBatchDocuments`.

16. **`listAnalyzeBatchResults`**

    - **Purpose**: Lists results of all batch document analyses.
    - **Dependencies**: Requires at least one batch analysis (`analyzeBatchDocuments`).

17. **`deleteAnalyzeBatchResult`**
    - **Purpose**: Deletes a batch analysis result.
    - **Dependencies**: Requires `getAnalyzeBatchResult`.

---

#### **Document Classifiers Operations**

18. **`listClassifiers`**

    - **Purpose**: Lists all document classifiers in the account.
    - **Dependencies**: None.

19. **`buildClassifier`**

    - **Purpose**: Builds a custom document classifier.
    - **Dependencies**: None.

20. **`getClassifier`**

    - **Purpose**: Retrieves detailed classifier information.
    - **Dependencies**: Requires `buildClassifier`.

21. **`deleteClassifier`**

    - **Purpose**: Deletes a specific document classifier.
    - **Dependencies**: None, typically executed after testing other classifier operations.

22. **`classifyDocumentFromStream`**

    - **Purpose**: Classifies a document using a classifier via raw stream input.
    - **Dependencies**: Requires an existing classifier (`buildClassifier`).
    - **Notes**: Must follow up with `getClassifyResult`.

23. **`classifyDocument`**

    - **Purpose**: Classifies a document using a classifier via JSON input.
    - **Dependencies**: Requires an existing classifier (`buildClassifier`).
    - **Notes**: Must follow up with `getClassifyResult`.

24. **`getClassifyResult`**

    - **Purpose**: Retrieves the results of a previously submitted document classification.
    - **Dependencies**: Requires `classifyDocumentFromStream` or `classifyDocument`.

25. **`authorizeClassifierCopy`**

    - **Purpose**: Generates authorization info for copying a classifier.
    - **Dependencies**: Requires an existing classifier (`buildClassifier`).

26. **`copyClassifierTo`**
    - **Purpose**: Copies a classifier to a destination account/region.
    - **Dependencies**: Requires `authorizeClassifierCopy`.

---

#### **Miscellaneous Operations**

27. **`listOperations`**

    - **Purpose**: Lists all operations for the service.
    - **Dependencies**: None.
    - **Notes**: Useful for baselining available functionality.

28. **`getOperation`**

    - **Purpose**: Retrieves details of any operation by its ID.
    - **Dependencies**: Requires running any long-running operation (e.g., `analyzeDocument`, `buildModel`).

29. **`getResourceDetails`**
    - **Purpose**: Provides general details about the resource (account).
    - **Dependencies**: None.

---

### **Recommended Test Execution Order**

Below is a high-level optimized execution order based on dependencies:

1. Service Initialization:

   - `listModels`
   - `listClassifiers`
   - `listOperations`
   - `getResourceDetails`

2. Document Model Testing:

   - `buildModel`
   - `listModels`
   - `getModel`
   - `composeModel`
   - `authorizeModelCopy`
   - `copyModelTo`

3. Document Analysis Testing:

   - `analyzeDocumentFromStream`
   - `getAnalyzeResult`
   - `getAnalyzeResultPdf`
   - `getAnalyzeResultFigure`
   - `deleteAnalyzeResult`

4. Batch Document Analysis Testing:

   - `analyzeBatchDocuments`
   - `getAnalyzeBatchResult`
   - `listAnalyzeBatchResults`
   - `deleteAnalyzeBatchResult`

5. Document Classifier Testing:

   - `buildClassifier`
   - `listClassifiers`
   - `getClassifier`
   - `classifyDocumentFromStream`
   - `getClassifyResult`
   - `authorizeClassifierCopy`
   - `copyClassifierTo`
   - `deleteClassifier`

6. Cleanup:

   - `deleteModel`
   - `deleteClassifier`

7. Operation Validation:
   - `getOperation`

### **Execution Notes**

- Each long-running operation (`buildModel`, `analyzeDocument`, etc.) must complete successfully before dependent operations.
- Ensure all "delete" operations are reserved for cleanup after all other tests.
- Validate the correctness of dependent metadata (e.g., `resultId`, `modelId`) throughout execution.
```

</details>

<!-- genaiscript output end -->

### Write The Test Script

**Goal:** Have copilot write a test for each of the operations making sure to run operations in order to guarantee preconditions for each are met.

**Challenges:** May not have all the required information in the routes.tsp which would involve iterating the operations and extracting data from other tsp files.

**Prompt:**

```js
script({ files: "DocumentInteligence/routes.tsp" });

def("ROUTES", env.files);
$`You are an expert REST API architect and developer.
Review the TypeSpec service definition in ROUTES and identify all operations available through the API.
We want to test all the operations defined in the service to make sure that the TypeSpec represents the service API correctly.
Some operations would require other operations to be run before they can run. For example, querying a resource needs to make sure that the operation for creating that resource
has completed and successfully executed.

Determine the order in which the operations need to be run to be able to test all the operations defined in the TypeSpec

Write to a shell script to tests all the operations defined in the spec, the request needs to yield a valid response as described in the spec to be considered successful and move on to the next request. Use placeholders for the actual data.

Make sure to consider the order determined above. As part of the script write as a multiline comment a summary of the execution plan.

Make sure to validate the responses according to the spec

Write the script to a sh file
`;

defFileOutput(
  "DocumentInteligence/typespec-service-test.sh",
  "the generated script"
);
```

### Add Test Data to the test script [In Progress see test.genai.mjs]

**Goal:** Have copilot edit the test script to add data from the examples json files.

**Challenges:** There might be a disconnect between the JSON and Spec how do we know when the spec doesn't match the JSON.

**Prompt:**

```js
script({ files: "DocumentInteligence/**/*" });

def("ROUTES", env.files, { endsWith: "routes.tsp" });
def("EXAMPLES", env.files, { endsWith: ".json" });
def("SCRIPT", env.files, { endsWith: "typespec-service-test.sh" });

for (const file of env.files) {
  const { text } = await runPrompt((_) => {
    _.def("FILE", file);
    _.$`Summarize the FILE.`;
  });
  def("FILE", { ...file, content: text });
}

$`You are an expert REST API architect and developer.
Review the TypeSpec service definition in ROUTES and identify all operations available through the API make sure you understand each operations input and output as defined in the spec.
We want to test all the operations defined in the service to make sure that the TypeSpec represents the service API correctly.
Some operations would require other operations to be run before they can run. For example, querying a resource needs to make sure that the operation for creating that resource
has completed and successfully executed.

This is an EXAMPLE of a request response, this example belongs to a specific operation in the spec, use this data to update and write the generated script SCRIPT, to fill the operation matching the sample with the data in the example.

`;

defFileOutput("typespec-service-test.sh", "the generated script");
```
