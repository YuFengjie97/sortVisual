<template>
  <div class="leftNav w-52 h-screen flex-col">
    <router-link
      :to="item.path"
      v-for="(item, i) in navList"
      :key="i"
      class="p-2 m-1 rounded-md bg-black transition-background duration-300 text-white text-center"
    >
      {{ item.meta.title }}
    </router-link>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { routes } from "../../routes";

const navList = ref(routes.slice(1, -1))

</script>

<style lang="less" scoped>
.leftNav {
  width: 200px;
  display: flex;
}
</style>
