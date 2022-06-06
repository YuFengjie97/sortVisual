<template>
<div class="leftNav w-52 h-screen flex-col">
    <router-link :to="item.path" v-for="(item,i) in navList" :key="i"
        class="p-2 m-1 rounded-md bg-green-800 hover:bg-green-400 transition-background duration-300 text-white text-center">
        {{item.meta.title}}
    </router-link>
</div>
</template>

<script setup>
import { ref} from 'vue'
import {routes} from '../../routes'

const navList = routes.slice(0, -1)

console.log(routes);

</script>

<style lang="less" scoped>
.leftNav{
    width: 200px;
    display: flex;
}
</style>