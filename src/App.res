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

  <>
    <h1> {"Tree Operations with ReScript"->React.string} </h1>
    {NodeHelpers.orderNodesByParent(nodeTree)
    ->Belt.Array.map(arr => {
      <div className="row-wrap">
        {arr
        ->Belt.Array.map(n => {
          <Node node={n} createChild={addChild} delete={deleteNode} />
        })
        ->React.array}
      </div>
    })
    ->React.array}
  </>
}
