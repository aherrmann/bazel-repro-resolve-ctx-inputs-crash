def _crash_impl(ctx):
    output = ctx.actions.declare_file(ctx.label.name)
    (inputs, input_manifests) = ctx.resolve_tools(tools = [ctx.attr.tool])
    ctx.actions.run(
        outputs = [output],
        executable = ctx.files.tool[1],
        arguments = [output.path],
        #inputs = inputs,  # UNCOMMENT THIS
        input_manifests = input_manifests,
    )
    return [DefaultInfo(
        files = depset(direct = [output]),
    )]

crash = rule(
    _crash_impl,
    attrs = {
        "tool": attr.label(
            cfg = "exec",
        ),
    },
)
