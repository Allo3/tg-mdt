<script lang="ts">
  import VisibilityProvider from './providers/VisibilityProvider.svelte'
  import TabletUI from './components/TabletUI.svelte'
  import { debugData } from './utils/debugData'
  debugData([{ action: 'setVisible', data: true }])
</script>

<main>
  <VisibilityProvider>
    <TabletUI />
  </VisibilityProvider>
  </main>
