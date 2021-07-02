%%raw("require('./App.css')")

@react.component
let make = () => {
  let (nodeTree, setNodeTree) = Recoil.useRecoilState(NodesStore.nodeTree)

  let addChild = (parentId: int) => {
    let updateTree = NodeHelpers.createChild(parentId, nodeTree, nodeTree)
    setNodeTree(_ => {...updateTree, children: updateTree.children})
  }

  let deleteNode = (id: int, parentId: int) => {
    let updateTree = NodeHelpers.deleteChild(
      ~deleteId=id,
      ~parentId,
      ~currentTree=nodeTree,
      ~nodeTree,
    )
    setNodeTree(_ => {...updateTree, children: updateTree.children})
  }

  let rec renderTree = (node: NodeTypes.node) => {
    <div>
      <Node node={node} createChild={addChild} delete={deleteNode} />
      {node.children->Belt.Array.length > 0
        ? {
            <div className="node-row">
              {node.children
              ->Belt.Array.map(n => {
                if n.children->Belt.Array.length == 0 {
                  <Node node={n} createChild={addChild} delete={deleteNode} />
                } else {
                  {renderTree(n)}
                }
              })
              ->React.array}
            </div>
          }
        : {
            <> </>
          }}
    </div>
  }

  <>
    <h1> {"Tree Operations with ReScript"->React.string} </h1>
    <div className="node-row "> {renderTree(nodeTree)} </div>
  </>
}
