let nodeTree: Recoil.t<NodeTypes.node, Recoil.readWriteMode> = Recoil.atom({
  key: "nodeTree",
  default: {
    NodeTypes.id: 1,
    parent: None,
    children: [],
  },
})
