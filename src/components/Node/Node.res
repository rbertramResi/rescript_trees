@react.component
let make = (~node: NodeTypes.node, ~createChild: int => unit, ~delete: (int, int) => unit) => {
  let resolveParentId = (parentId: option<int>) =>
    switch parentId {
    | None => -1
    | Some(n) => n
    }

  let renderDelete = () =>
    switch node.parent {
    | None => <> </>
    | Some(_) =>
      <button className="delete" onClick={_ => delete(node.id, resolveParentId(node.parent))}>
        {"-"->React.string}
      </button>
    }

  <div className="card">
    <button className="add" onClick={_ => createChild(node.id)}> {"+"->React.string} </button>
    {renderDelete()}
  </div>
}
