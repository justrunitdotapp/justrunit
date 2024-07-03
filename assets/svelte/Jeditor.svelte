<script>
  import { Pane, Splitpanes } from "svelte-splitpanes";
  import { onMount } from "svelte";
  import Monaco from "svelte-monaco";

  let textarea;

  let value = "Test";
</script>

<Splitpanes style="height: 50vh; padding: 0.6%;">
  <Pane minSize={5} size={60}>
    <div class="p-2 text-sm rounded-lg border border-blue-400 size-full">
      <Splitpanes style="padding: 0.6%;">
        <Pane minSize={5} size={15}>
          <ul class="pr-2 w-full h-full border-r-2 border-neutral-300">
            <li>
              <button class="w-full text-left hover:bg-slate-300"
                >Plik1.ex</button
              >
            </li>
            <li>
              <button class="w-full text-left hover:bg-slate-300"
                >Plik1.ex</button
              >
            </li>
            <li>
              <button class="w-full text-left hover:bg-slate-300"
                >Plik1.ex</button
              >
            </li>
          </ul>
        </Pane>
        <Pane minSize={5} size={85}>
          <div class="p-1 h-full border-l-2 border-neutral-300">
            <Monaco />
          </div>
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
