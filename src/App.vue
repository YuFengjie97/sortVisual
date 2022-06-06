<template>
  <router-view />
</template>

<script setup>
import { ref } from 'vue'

let counter = ref(0)

setInterval(() => {
  counter.value++
}, 1000)
</script>
<style lang="less" scoped>

</style>