script({ model: "github:gpt-4o", files: "DocumentInteligence/**/*" });

def("SCRIPT", env.files, { endsWith: ".sh" });
def("ROUTES", env.files, { endsWith: "routes.tsp" });

const examples = [
  env.files.filter((file) => file.filename.endsWith(".json"))[0],
];

for (const file of examples) {
  const { text } = await runPrompt((_) => {
    _.def("FILE", file);
    _.$`You are an expert REST API architect and developer.
Review the TypeSpec service definition in ROUTES and identify all operations available through the API make sure you understand each operations input and output as defined in the spec.
We want to test all the operations defined in the service to make sure that the TypeSpec represents the service API correctly.
Some operations would require other operations to be run before they can run. For example, querying a resource needs to make sure that the operation for creating that resource
has completed and successfully executed.

This FILE contains an example of a request response, this example belongs to a specific operation in the spec, use this data to update and write the generated script SCRIPT, to fill the operation matching the sample with the data in the example.

Update SCRIPT so that the operation matching the example is filled with the data in the example.
`;
  });
}
