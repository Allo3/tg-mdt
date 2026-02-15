<script lang="ts">
  import VisibilityProvider from './providers/VisibilityProvider.svelte'
  import TabletUI from './components/TabletUI.svelte'
  import { debugData } from './utils/debugData'

  // 👇 Ouvre automatiquement UNIQUEMENT en navigateur dev
  if (import.meta.env.DEV) {
    debugData([{ action: 'setVisible', data: true }])
  }
</script>

<main>
  <VisibilityProvider>
    <TabletUI />
  </VisibilityProvider>
  </main>
