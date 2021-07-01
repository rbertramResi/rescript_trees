@react.component
let make = (~node: NodeTypes.node, ~createChild: int => unit, ~delete: (int, int) => unit) => {
  let resolveParentId = (parentId: option<int>) =>
    switch parentId {
    | None => -1
    | Some(n) => n
    }

  let renderDelete = () => {
    if resolveParentId(node.parent) != -1 {
      <button onClick={_ => delete(node.id, resolveParentId(node.parent))}>
        {"Delete"->React.string}
      </button>
    } else {
      <> </>
    }
  }

  <div className="card">
    <div> {"ID "->React.string} {node.id->Belt.Int.toString->React.string} </div>
    <div>
      {"PARENT ID "->React.string} {resolveParentId(node.parent)->Belt.Int.toString->React.string}
    </div>
    <button onClick={_ => createChild(node.id)}> {"Create Child"->React.string} </button>
    {renderDelete()}
  </div>
}
