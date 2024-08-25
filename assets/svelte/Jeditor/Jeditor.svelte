<script>
  import { onMount } from "svelte";
  import { Pane, Splitpanes } from "svelte-splitpanes";

  onMount(() => {});
  export let s3_keys;
  export let justbox_name;
  export let live;
  export let value;
  import Tree from "./Filetree.svelte";
  import Tabs from "./Tabs.svelte";
  import Editor from "./Editor.svelte";
</script>

<Splitpanes style="height: 50vh; padding: 0.6%;">
  <Pane minSize={5} size={60}>
    <div class="p-2 text-sm rounded-lg border border-blue-400 size-full">
      <Splitpanes style="padding: 0.6%;">
        <Pane minSize={5} size={20}></Pane>
        <Tree live justbox_name s3_keys />
        <Pane minSize={5} size={80}>
          <Tabs />
          <Editor value />
        </Pane>
      </Splitpanes>
    </div>
  </Pane>
  <Pane size={40}>
    <div class="rounded-lg border border-blue-400 size-full">
      <div
        class="px-2 py-1 space-x-2 text-sm font-medium bg-blue-400 rounded-t"
      >
        <button class="px-2 bg-blue-500 rounded text-zinc-200 hover:bg-blue-600"
          >Just Run It
        </button>
        <button class="px-2 bg-blue-500 rounded text-zinc-200 hover:bg-blue-600"
          >Clear
        </button>
      </div>
    </div>
  </Pane>
</Splitpanes>
