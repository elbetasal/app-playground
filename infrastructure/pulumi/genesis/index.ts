import * as pulumi from "@pulumi/pulumi";
import * as docker from "@pulumi/docker";

const stack = pulumi.getStack();
const config = new pulumi.Config();


const backendPort = config.requireNumber("backend_port");
const backendImageName = "backend";
const backend = new docker.Image("backend", {
  build: {
    context: `${process.cwd()}/backend`,
  },
  imageName: `${backendImageName}:${stack}`,
  skipPush: true,
});

// create a network!
const network = new docker.Network("network", {
  name: `services-${stack}`,
});

// create the backend container!
const backendContainer = new docker.Container("backendContainer", {
  name: `backend-${stack}`,
  image: backend.baseImageName,
  ports: [
    {
      internal: backendPort,
      external: backendPort,
    },
  ],
  networksAdvanced: [
    {
      name: network.name,
    },
  ],
}, );

export const url = pulumi.interpolate`http://localhost:${backendPort}`;

