Run the following commands to reproduce the crash:

```
$ USE_BAZEL_VERSION=last_green bazel build //:crash
2022/06/28 16:00:06 Using unreleased version at commit de491da931cef4b063f93d20747256ae38518160
...
FATAL: bazel crashed due to an internal error. Printing stack trace:
java.lang.RuntimeException: Unrecoverable error while evaluating node 'ActionLookupData{actionLookupKey=ConfiguredTargetKey{label=//:crash, config=BuildConfigurationKey[cf45c98382a5425c9423e9818198d63bfc53a7210804a6e52827c219c726f757]}, actionIndex=0}' (requested by nodes 'TargetCompletionKey{topLevelArtifactContext=com.google.devtools.build.lib.analysis.TopLevelArtifactContext@90904c3b, actionLookupKey=ConfiguredTargetKey{label=//:crash, config=BuildConfigurationKey[cf45c98382a5425c9423e9818198d63bfc53a7210804a6e52827c219c726f757]}, willTest=false}')
        at com.google.devtools.build.skyframe.AbstractParallelEvaluator$Evaluate.run(AbstractParallelEvaluator.java:665)
        at com.google.devtools.build.lib.concurrent.AbstractQueueVisitor$WrappedRunnable.run(AbstractQueueVisitor.java:382)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
        at java.base/java.lang.Thread.run(Unknown Source)
Caused by: java.lang.IllegalStateException: File:[/home/aj/.cache/bazel/_bazel_aj/8758014692deaa5c41d233f7a8ed2db2/external/bazel_tools[source]]tools/bash/runfiles/runfiles.bash is not present in declared outputs: [File:[[<execution_root>]bazel-out/k8-fastbuild/bin]crash]
        at com.google.common.base.Preconditions.checkState(Preconditions.java:821)
        at com.google.devtools.build.lib.skyframe.ActionMetadataHandler.getMetadata(ActionMetadataHandler.java:249)
        at com.google.devtools.build.lib.skyframe.SkyframeActionExecutor$DelegatingPairFileCache.getMetadata(SkyframeActionExecutor.java:1766)
        at com.google.devtools.build.lib.remote.merkletree.DirectoryTreeBuilder.lambda$buildFromActionInputs$1(DirectoryTreeBuilder.java:141)
        at com.google.devtools.build.lib.remote.merkletree.DirectoryTreeBuilder.build(DirectoryTreeBuilder.java:221)
        at com.google.devtools.build.lib.remote.merkletree.DirectoryTreeBuilder.buildFromActionInputs(DirectoryTreeBuilder.java:125)
        at com.google.devtools.build.lib.remote.merkletree.DirectoryTreeBuilder.fromActionInputs(DirectoryTreeBuilder.java:63)
        at com.google.devtools.build.lib.remote.merkletree.MerkleTree.build(MerkleTree.java:219)
        at com.google.devtools.build.lib.remote.RemoteExecutionService.buildInputMerkleTree(RemoteExecutionService.java:358)
        at com.google.devtools.build.lib.remote.RemoteExecutionService.buildRemoteAction(RemoteExecutionService.java:406)
        at com.google.devtools.build.lib.remote.RemoteSpawnCache.lookup(RemoteSpawnCache.java:93)
        at com.google.devtools.build.lib.exec.AbstractSpawnStrategy.exec(AbstractSpawnStrategy.java:144)
        at com.google.devtools.build.lib.exec.AbstractSpawnStrategy.exec(AbstractSpawnStrategy.java:111)
        at com.google.devtools.build.lib.actions.SpawnStrategy.beginExecution(SpawnStrategy.java:47)
        at com.google.devtools.build.lib.exec.SpawnStrategyResolver.beginExecution(SpawnStrategyResolver.java:64)
        at com.google.devtools.build.lib.analysis.actions.SpawnAction.beginExecution(SpawnAction.java:351)
        at com.google.devtools.build.lib.actions.Action.execute(Action.java:133)
        at com.google.devtools.build.lib.skyframe.SkyframeActionExecutor$5.execute(SkyframeActionExecutor.java:924)
        at com.google.devtools.build.lib.skyframe.SkyframeActionExecutor$ActionRunner.continueAction(SkyframeActionExecutor.java:1091)
        at com.google.devtools.build.lib.skyframe.SkyframeActionExecutor$ActionRunner.run(SkyframeActionExecutor.java:1049)
        at com.google.devtools.build.lib.skyframe.ActionExecutionState.runStateMachine(ActionExecutionState.java:152)
        at com.google.devtools.build.lib.skyframe.ActionExecutionState.getResultOrDependOnFuture(ActionExecutionState.java:91)
        at com.google.devtools.build.lib.skyframe.SkyframeActionExecutor.executeAction(SkyframeActionExecutor.java:497)
        at com.google.devtools.build.lib.skyframe.ActionExecutionFunction.checkCacheAndExecuteIfNeeded(ActionExecutionFunction.java:819)
        at com.google.devtools.build.lib.skyframe.ActionExecutionFunction.computeInternal(ActionExecutionFunction.java:318)
        at com.google.devtools.build.lib.skyframe.ActionExecutionFunction.compute(ActionExecutionFunction.java:163)
        at com.google.devtools.build.skyframe.AbstractParallelEvaluator$Evaluate.run(AbstractParallelEvaluator.java:591)
        ... 4 more
```

Run the following commands to avoid the crash:

```
$ sed -i.bak '/UNCOMMENT THIS/s/#//' defs.bzl

$ USE_BAZEL_VERSION=last_green bazel build //:crash
...
INFO: Build completed successfully, 5 total actions
```
