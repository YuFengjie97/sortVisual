<script>
import { ref, watch } from "vue"
import { height } from "tailwindcss/defaultTheme"
export default {
  props: {
    arr: {
      type: Array,
    },
  },
  setup(props) {
    console.log("grid props", props)
    let min = 0
    let max = 0

    function setM() {
      min = Math.min(...props.arr)
      max = Math.max(...props.max)
    }

    function getHeight(val) {
      const minH = 10
      const maxH = 400
      const valH = (maxH / max) * val
      return valH < minH ? minH : valH
    }

    watch(
      () => props.arr,
      (val) => {
        min = Math.min(...props.arr)
        max = Math.max(...props.max)
        console.log(val)
      }
    )
    return () => (
      <div class="grid">
        {props.arr.map((item) => {
          const height = getHeight(item)
          return <div style="height:{height}px" class="item">{item}</div>
        })}
      </div>
    )
  },
}
</script>

<style lang="less" scoped>
.grid {
  display: grid;
  grid-template-columns: repeat(auto, 1fr);
  grid-template-rows: 400px;
  gap: 4px;
  border: 1px solid #000;
  .item {
    background: red;
    min-width: 20px;
  }
}
</style>
