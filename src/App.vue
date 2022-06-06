<template>
  <div class="flex">
    <LeftNav/>
    <div class="viewCon p-4 flex-grow">
      <router-view />
    </div>
  </div>
</template>

<script setup>
import LeftNav from '@/components/leftNav/index.vue'
import { ref } from "vue";

let counter = ref(0);

setInterval(() => {
  counter.value++;
}, 1000);
</script>
<style lang="less" scoped></style>
