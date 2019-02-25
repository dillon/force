import React from "react"
import { Box } from "@artsy/palette"
import { SearchBarQueryRenderer } from "reaction/Components/Search/SearchBar"
import styled from "styled-components"

const SearchBarContainer = styled(Box)`
  z-index: 100;
`

export const SearchBar = () => (
  <SearchBarContainer pt={1} pb={0.5}>
    <SearchBarQueryRenderer />
  </SearchBarContainer>
)
