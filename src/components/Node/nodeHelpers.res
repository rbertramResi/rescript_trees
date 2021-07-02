%%raw("require('./Node.css')")

let rec isChildOf = (node: NodeTypes.node, rootId: int): bool => {
  let resolvedParent = switch node.parent {
  | None => -1
  | Some(id) => id
  }

  if resolvedParent == rootId {
    true
  } else if node.children->Belt.Array.length > 0 {
    node.children->Belt.Array.some(n => {
      isChildOf(n, rootId)
    })
  } else {
    false
  }
}

let rec createChild = (
  parentId: int,
  currentTree: NodeTypes.node,
  nodeTree: NodeTypes.node,
): NodeTypes.node => {
  let newChild: NodeTypes.node = {
    id: NodeUtils.randomId(),
    parent: Some(parentId),
    children: [],
  }

  if parentId == currentTree.id {
    let _ = currentTree.children->Js.Array2.push(newChild)
    nodeTree
  } else {
    let _ = currentTree.children->Belt.Array.getBy(n => {
      if n.id == parentId {
        let _ = n.children->Js.Array2.push(newChild)
        true
      } else {
        let _ = createChild(parentId, n, nodeTree)
        false
      }
    })
    nodeTree
  }
}

let rec deleteChild = (
  ~deleteId: int,
  ~parentId: int,
  ~currentTree: NodeTypes.node,
  ~nodeTree: NodeTypes.node,
): NodeTypes.node => {
  if currentTree.id == parentId {
    currentTree.children = currentTree.children->Belt.Array.keep(c => c.id != deleteId)
    nodeTree
  } else {
    let _ = currentTree.children->Belt.Array.getBy(c => {
      let result = deleteChild(~deleteId, ~parentId, ~currentTree=c, ~nodeTree)
      deleteId == result.id
    })
    nodeTree
  }
}

let rec flattenNodes = (tree: NodeTypes.node): array<NodeTypes.node> => {
  let flatArr: array<NodeTypes.node> = [tree]
  if tree.children->Belt.Array.length == 0 {
    flatArr
  } else {
    let _ = flatArr->Js.Array2.concat(tree.children)

    let mappedNodes =
      tree.children
      ->Belt.Array.map(n => {
        flattenNodes(n)
      })
      ->Belt.Array.concatMany

    flatArr->Belt.Array.concat(mappedNodes)
  }
}

let orderNodesByParent = (tree: NodeTypes.node) => {
  let nestedArr: array<array<NodeTypes.node>> = []
  tree
  ->flattenNodes
  ->Belt.Array.forEach(node => {
    let found = ref(false)
    nestedArr->Belt.Array.forEach(arr => {
      if arr->Belt.Array.some(n => n.parent == node.parent) {
        let _ = arr->Js.Array2.push(node)
        found.contents = true
      }
    })
    if found.contents == false {
      let _ = nestedArr->Js.Array2.push([node])
    }
  })
  nestedArr
}
