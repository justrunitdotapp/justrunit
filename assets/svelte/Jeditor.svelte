<script>
  import { Pane, Splitpanes } from 'svelte-splitpanes';
</script>

<Splitpanes style="height: 400px">
  <Pane minSize={20}>
    1
    <br />
    <em class="specs">I have a min width of 20%</em>
  </Pane>
  <Pane>
    <Splitpanes horizontal={true}>
      <Pane minSize={15}>
        2
        <br />
        <em class="specs">I have a min height of 15%</em>
      </Pane>
      <Pane>3</Pane>
      <Pane>4</Pane>
    </Splitpanes>
  </Pane>
  <Pane>5</Pane>
</Splitpanes>