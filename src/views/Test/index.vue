<template>
<button @click="changeOrder">changeOrder</button>
<div class="con">
    <div class="item" v-for="(item,i) in order" :key="i" :style="`order: ${item}`">{{i}}</div>
</div>
</template>

<script setup>
import { ref} from 'vue';
const order = ref([1,2,3,4,5])

function changeOrder(){
    order.value = [4,2,3,5,1]
}
</script>

<style lang="less" scoped>
.con{
    display: flex;
    flex-wrap: nowrap;
    gap: 10px;
    .item{
        background: red;
        width: 30px;
        height: 30px;
        text-align: center;
        transition: .3s;
    }
}
</style>