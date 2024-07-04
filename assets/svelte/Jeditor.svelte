<script>
  import { Pane, Splitpanes } from "svelte-splitpanes";
  import { onMount } from "svelte";
  // import Monaco from "svelte-monaco";
  import { Icon, DocumentPlus, FolderPlus, ArrowPath } from "svelte-hero-icons";
  export let s3_keys;
  export let justbox_name;

  let textarea;

  let value = "Test";

  onMount(() => {});
</script>

<Splitpanes style="height: 50vh; padding: 0.6%;">
  <Pane minSize={5} size={60}>
    <div class="p-2 text-sm rounded-lg border border-blue-400 size-full">
      <Splitpanes style="padding: 0.6%;">
        <Pane minSize={5} size={20}>
          {#if s3_keys === null}
            <div class="text-center">
              <h2 class="text-xl font-medium text-center">Error</h2>
              <p>Failed to fetch files names</p>
            </div>
          {:else}
            <ul
              class="pr-2 w-full h-full truncate border-r-2 border-neutral-300"
            >
              <div
                class="flex justify-between p-1 text-sm font-medium text-white bg-blue-500 rounded-t"
              >
                <h2>{justbox_name}</h2>
                <div class="flex items-center space-x-1">
                  <button class="hover:bg-blue-400" title="Refresh explorer">
                    <Icon src={ArrowPath} size="20" />
                  </button>
                  <button class="hover:bg-blue-400" title="New File">
                    <Icon src={DocumentPlus} size="20" />
                  </button>
                  <button class="hover:bg-blue-400" title="New Folder">
                    <Icon src={FolderPlus} size="20" />
                  </button>
                </div>
              </div>
              {#each s3_keys as s3_key}
                <li>
                  <button class="w-full text-left hover:bg-slate-300"
                    >{s3_key}</button
                  >
                </li>
              {/each}
            </ul>
          {/if}
        </Pane>
        <Pane minSize={5} size={80}>
          <div class="p-1 h-full border-l-2 border-neutral-300">
            <!-- <Monaco
              theme="vs-light"
              options={{ language: "elixir" }}
              bind:value
            />-->
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
