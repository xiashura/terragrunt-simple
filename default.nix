
with (import <nixpkgs> {});

let
 init = pkgs.writeShellScriptBin "init" ''
  docker-compose up -d 
  docker exec -it localstack_main awslocal s3api create-bucket \
   --no-sign-request --bucket my-bucket --region eu-west-1
  '';

  terragrunt-svg = pkgs.writeShellScriptBin "svg" ''
  terragrunt graph-dependencies | dot -Tsvg > graph.svg
  '';

in

 

stdenv.mkDerivation {


  name = "aws-local-terraform";
  buildInputs = [
    init
    terraform
    terragrunt
    awscli2
    jq
    graphviz-nox
    terragrunt-svg
  ];
}